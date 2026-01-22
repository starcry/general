#!/bin/bash
set -e

# Configuration
REPO_DIR="$HOME/git/general"
LOG_FILE="$REPO_DIR/install.log"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
    echo "[INFO] $1" >> "$LOG_FILE"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
    echo "[SUCCESS] $1" >> "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
    echo "[ERROR] $1" >> "$LOG_FILE"
}

# Ensure we are in the right directory
if [ ! -d "$REPO_DIR" ]; then
    error "Repository directory not found at $REPO_DIR. Please clone it there."
    exit 1
fi

log "Starting installation..."

# 1. System Updates and Core Dependencies
log "Updating system packages..."
sudo apt-get update -y
sudo apt-get upgrade -y
sudo apt-get install -y \
    git \
    curl \
    wget \
    build-essential \
    unzip \
    jq \
    xclip \
    tmux \
    python3 \
    python3-pip \
    python3-venv \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# 2. Utility Tools (ripgrep, fd, bat)
log "Installing utility tools (ripgrep, fd, bat)..."
sudo apt-get install -y ripgrep fd-find bat

# Fix bat -> batcat and fd -> fdfind symlinks if they don't exist
if ! command -v bat &> /dev/null; then
    if command -v batcat &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf $(which batcat) ~/.local/bin/bat
        log "Symlinked batcat to bat"
    fi
fi
if ! command -v fd &> /dev/null; then
    if command -v fdfind &> /dev/null; then
        mkdir -p ~/.local/bin
        ln -sf $(which fdfind) ~/.local/bin/fd
        log "Symlinked fdfind to fd"
    fi
fi

# 3. Neovim Install
if ! command -v nvim &> /dev/null; then
    log "Installing Neovim..."
    cd /tmp
    wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    # Add to path if not already there (assuming /opt/nvim-linux64/bin)
    # Ideally link it to /usr/local/bin
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz
    success "Neovim installed"
else
    log "Neovim already installed"
fi

# 4. NVM and Node.js
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    log "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    success "NVM and Node LTS installed"
else
    log "NVM already installed"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 5. AWS CLI v2
if ! command -v aws &> /dev/null; then
    log "Installing AWS CLI v2..."
    cd /tmp
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip -q awscliv2.zip
    sudo ./aws/install
    rm awscliv2.zip
    rm -rf aws
    success "AWS CLI installed"
else
    log "AWS CLI already installed"
fi

# 6. Terraform
if ! command -v terraform &> /dev/null; then
    log "Installing Terraform..."
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg --yes
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update && sudo apt-get install terraform -y
    success "Terraform installed"
else
    log "Terraform already installed"
fi

# 7. Terragrunt
if ! command -v terragrunt &> /dev/null; then
    log "Installing Terragrunt..."
    TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    wget "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64"
    chmod +x terragrunt_linux_amd64
    sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt
    success "Terragrunt installed"
else
   log "Terragrunt already installed"
fi

# 8. Kubectl
if ! command -v kubectl &> /dev/null; then
    log "Installing Kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
    success "Kubectl installed"
else
    log "Kubectl already installed"
fi

# 9. Minikube
if ! command -v minikube &> /dev/null; then
    log "Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
    success "Minikube installed"
else
    log "Minikube already installed"
fi

# 10. Dotfiles Symlinking
log "Linking dotfiles..."
BACKUP_DIR="$HOME/dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

link_file() {
    local src=$1
    local dest=$2
    
    if [ -f "$dest" ] || [ -d "$dest" ]; then
        if [ -L "$dest" ]; then
             # It's already a symlink, check where it points
             local current_target=$(readlink -f "$dest")
             if [ "$current_target" == "$src" ]; then
                 log "Skipping $dest, already correctly linked."
                 return
             fi
        fi
        log "Backing up existing $dest to $BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi
    ln -s "$src" "$dest"
    success "Linked $src -> $dest"
}

link_file "$REPO_DIR/bashrc" "$HOME/.bashrc"
link_file "$REPO_DIR/tmux.conf" "$HOME/.tmux.conf"
link_file "$REPO_DIR/vimrc" "$HOME/.vimrc"

# Neovim Config
mkdir -p "$HOME/.config"
link_file "$REPO_DIR/nvim" "$HOME/.config/nvim"

# 11. Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    log "Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    log "TPM already installed"
fi

# 12. Finalize
log "Installation complete!"
log "Please restart your shell or run 'source ~/.bashrc'"
log "To install Tmux plugins, press <prefix> + I inside Tmux."
log "Neovim plugins will auto-install on first launch."

