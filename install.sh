#!/usr/bin/env bash
# Bootstrap this repo on a fresh Ubuntu machine:
#   packages, tooling, TPM, and symlinked dotfiles (edits stay in-repo).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="${REPO_DIR:-$SCRIPT_DIR}"
EXPECTED_DIR="$HOME/git/general"
LOG_FILE="$REPO_DIR/install.log"
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

log()     { echo -e "${BLUE}[INFO]${NC} $1";    echo "[INFO] $1"    >> "$LOG_FILE"; }
success() { echo -e "${GREEN}[OK]${NC} $1";     echo "[OK] $1"      >> "$LOG_FILE"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1";  echo "[WARN] $1"    >> "$LOG_FILE"; }
error()   { echo -e "${RED}[ERROR]${NC} $1";    echo "[ERROR] $1"   >> "$LOG_FILE"; }

need_cmd() { command -v "$1" >/dev/null 2>&1; }

arch="$(uname -m)"
case "$arch" in
  x86_64|amd64) NVIM_ARCH="x86_64"; TG_ARCH="amd64"; KUBE_ARCH="amd64" ;;
  aarch64|arm64) NVIM_ARCH="arm64"; TG_ARCH="arm64"; KUBE_ARCH="arm64" ;;
  *) error "Unsupported architecture: $arch"; exit 1 ;;
esac

: > "$LOG_FILE"
log "Starting install from $REPO_DIR (arch=$arch)"

if [[ "$REPO_DIR" != "$EXPECTED_DIR" ]]; then
  warn "Repo is at $REPO_DIR but bashrc expects $EXPECTED_DIR."
  warn "Clone/move to $EXPECTED_DIR (or update paths in bashrc) for best results."
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
link_path() {
  local src=$1
  local dest=$2

  if [[ ! -e "$src" ]]; then
    error "Missing source for link: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dest")"

  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink -f "$dest" 2>/dev/null || true)"
    if [[ "$current" == "$(readlink -f "$src")" ]]; then
      log "Already linked: $dest"
      return 0
    fi
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    mkdir -p "$BACKUP_DIR"
    log "Backing up $dest -> $BACKUP_DIR/"
    mv "$dest" "$BACKUP_DIR/"
  fi

  ln -s "$src" "$dest"
  success "Linked $dest -> $src"
}

install_deb_url() {
  # install_deb_url <url> <pkg-name-for-logs>
  local url=$1
  local name=$2
  local tmp
  tmp="$(mktemp /tmp/"$name".XXXXXX.deb)"
  curl -fsSL "$url" -o "$tmp"
  sudo apt-get install -y "$tmp"
  rm -f "$tmp"
}

# ---------------------------------------------------------------------------
# 1. System packages
# ---------------------------------------------------------------------------
log "Updating apt and installing base packages..."
sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git curl wget build-essential unzip zip jq \
  xclip tmux \
  python3 python3-pip python3-venv \
  software-properties-common apt-transport-https ca-certificates gnupg lsb-release \
  ripgrep fd-find bat fzf \
  dnsutils inotify-tools \
  luarocks

mkdir -p "$HOME/.local/bin"

# Ubuntu names these batcat / fdfind
if ! need_cmd bat && need_cmd batcat; then
  ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  success "Symlinked batcat -> ~/.local/bin/bat"
fi
if ! need_cmd fd && need_cmd fdfind; then
  ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
  success "Symlinked fdfind -> ~/.local/bin/fd"
fi

# Ensure ~/.local/bin is early on PATH for this script
export PATH="$HOME/.local/bin:$PATH"

# ---------------------------------------------------------------------------
# 2. zoxide + glow (used by bashrc)
# ---------------------------------------------------------------------------
if ! need_cmd zoxide; then
  log "Installing zoxide..."
  curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
  success "zoxide installed"
else
  log "zoxide already installed"
fi

if ! need_cmd glow; then
  log "Installing glow..."
  # Prefer official .deb when available; fall back to go if present.
  GLOW_VERSION="$(curl -fsSL https://api.github.com/repos/charmbracelet/glow/releases/latest | jq -r .tag_name)"
  GLOW_VER_NUM="${GLOW_VERSION#v}"
  if [[ "$NVIM_ARCH" == "x86_64" ]]; then
    install_deb_url \
      "https://github.com/charmbracelet/glow/releases/download/${GLOW_VERSION}/glow_${GLOW_VER_NUM}_amd64.deb" \
      glow || warn "glow deb install failed; install manually if needed"
  else
    install_deb_url \
      "https://github.com/charmbracelet/glow/releases/download/${GLOW_VERSION}/glow_${GLOW_VER_NUM}_arm64.deb" \
      glow || warn "glow deb install failed; install manually if needed"
  fi
else
  log "glow already installed"
fi

# ---------------------------------------------------------------------------
# 3. Neovim (official tarball — newer than Ubuntu apt)
# ---------------------------------------------------------------------------
install_neovim() {
  local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
  local tmp="/tmp/nvim-linux-${NVIM_ARCH}.tar.gz"
  log "Installing Neovim from $url ..."
  curl -fsSL "$url" -o "$tmp"
  sudo rm -rf /opt/nvim-linux-"$NVIM_ARCH" /opt/nvim
  sudo tar -C /opt -xzf "$tmp"
  # Release layout: /opt/nvim-linux-<arch>/bin/nvim
  sudo ln -sfn /opt/nvim-linux-"$NVIM_ARCH"/bin/nvim /usr/local/bin/nvim
  rm -f "$tmp"
  success "Neovim $(nvim --version | head -1) installed"
}

if need_cmd nvim; then
  log "Neovim already present: $(nvim --version | head -1)"
else
  install_neovim
fi

# ---------------------------------------------------------------------------
# 4. NVM + Node LTS
# ---------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
  log "Installing NVM..."
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
fi
# shellcheck disable=SC1091
. "$NVM_DIR/nvm.sh"
if ! nvm ls --no-colors default >/dev/null 2>&1; then
  nvm install --lts
  nvm alias default 'lts/*'
fi
nvm use default >/dev/null
success "Node $(node -v) via nvm"

# Useful globals for the nvim stack
npm install -g typescript typescript-language-server tree-sitter-cli >/dev/null
success "Global npm tools installed (typescript, tsserver, tree-sitter-cli)"

# ---------------------------------------------------------------------------
# 5. AWS CLI + Session Manager plugin (ssm/sst aliases)
# ---------------------------------------------------------------------------
if ! need_cmd aws; then
  log "Installing AWS CLI v2..."
  pushd /tmp >/dev/null
  if [[ "$NVIM_ARCH" == "x86_64" ]]; then
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
  else
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o awscliv2.zip
  fi
  unzip -q awscliv2.zip
  sudo ./aws/install
  rm -rf aws awscliv2.zip
  popd >/dev/null
  success "AWS CLI installed"
else
  log "AWS CLI already installed"
fi

if ! need_cmd session-manager-plugin; then
  log "Installing AWS Session Manager plugin..."
  if [[ "$NVIM_ARCH" == "x86_64" ]]; then
    install_deb_url \
      "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" \
      session-manager-plugin
  else
    install_deb_url \
      "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_arm64/session-manager-plugin.deb" \
      session-manager-plugin
  fi
  success "session-manager-plugin installed"
else
  log "session-manager-plugin already installed"
fi

# ---------------------------------------------------------------------------
# 6. Terraform
# ---------------------------------------------------------------------------
if ! need_cmd terraform; then
  log "Installing Terraform..."
  wget -qO- https://apt.releases.hashicorp.com/gpg \
    | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --yes
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    | sudo tee /etc/apt/sources.list.d/hashicorp.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y terraform
  success "Terraform installed"
else
  log "Terraform already installed"
fi

# ---------------------------------------------------------------------------
# 7. Terragrunt
# ---------------------------------------------------------------------------
if ! need_cmd terragrunt; then
  log "Installing Terragrunt..."
  TG_VERSION="$(curl -fsSL https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r .tag_name)"
  curl -fsSL \
    "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_${TG_ARCH}" \
    -o /tmp/terragrunt
  chmod +x /tmp/terragrunt
  sudo mv /tmp/terragrunt /usr/local/bin/terragrunt
  success "Terragrunt ${TG_VERSION} installed"
else
  log "Terragrunt already installed"
fi

# ---------------------------------------------------------------------------
# 8. kubectl + minikube
# ---------------------------------------------------------------------------
if ! need_cmd kubectl; then
  log "Installing kubectl..."
  KVER="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
  curl -fsSL "https://dl.k8s.io/release/${KVER}/bin/linux/${KUBE_ARCH}/kubectl" -o /tmp/kubectl
  sudo install -o root -g root -m 0755 /tmp/kubectl /usr/local/bin/kubectl
  rm -f /tmp/kubectl
  success "kubectl ${KVER} installed"
else
  log "kubectl already installed"
fi

if ! need_cmd minikube; then
  log "Installing minikube..."
  curl -fsSL "https://storage.googleapis.com/minikube/releases/latest/minikube-linux-${KUBE_ARCH}" -o /tmp/minikube
  sudo install /tmp/minikube /usr/local/bin/minikube
  rm -f /tmp/minikube
  success "minikube installed"
else
  log "minikube already installed"
fi

# ---------------------------------------------------------------------------
# 9. Dotfile symlinks (edit in-repo, live config follows)
# ---------------------------------------------------------------------------
log "Linking dotfiles..."

link_path "$REPO_DIR/bashrc"    "$HOME/.bashrc"
link_path "$REPO_DIR/tmux.conf" "$HOME/.tmux.conf"
link_path "$REPO_DIR/vimrc"     "$HOME/.vimrc"

# Match current machine layout: link nvim pieces, keep lazy-lock.json local
mkdir -p "$HOME/.config/nvim"
link_path "$REPO_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_path "$REPO_DIR/nvim/lua"      "$HOME/.config/nvim/lua"

# ---------------------------------------------------------------------------
# 10. TPM + plugins (resurrect/continuum/etc.)
# ---------------------------------------------------------------------------
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  log "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  success "TPM cloned"
else
  log "TPM already installed"
fi

log "Installing tmux plugins via TPM..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" || warn "TPM plugin install returned non-zero (ok if tmux not running yet)"
success "tmux plugins present under ~/.tmux/plugins"

# ---------------------------------------------------------------------------
# 11. Done
# ---------------------------------------------------------------------------
cat <<EOF

$(echo -e "${GREEN}Install complete.${NC}")

Next steps:
  1. Restart your shell (or: source ~/.bashrc)
  2. Open nvim once — Lazy will bootstrap plugins on first launch
  3. Open tmux — plugins are already installed; use Ctrl-b Q to save/quit,
     and Ctrl-b Ctrl-r to restore after reboot

Symlinks:
  ~/.bashrc              -> $REPO_DIR/bashrc
  ~/.tmux.conf           -> $REPO_DIR/tmux.conf
  ~/.vimrc               -> $REPO_DIR/vimrc
  ~/.config/nvim/init.lua -> $REPO_DIR/nvim/init.lua
  ~/.config/nvim/lua      -> $REPO_DIR/nvim/lua

Backups (if anything was replaced): $BACKUP_DIR
Log: $LOG_FILE
EOF
