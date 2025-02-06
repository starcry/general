# Use Ubuntu as the base image
FROM ubuntu:latest

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && apt install -y \
    curl wget git unzip tar xz-utils \
    build-essential cmake python3 python3-pip python3-venv \
    neovim \
    fzf ripgrep silversearcher-ag \
    nodejs npm \
    unzip sudo fd-find \
    && rm -rf /var/lib/apt/lists/*

# Create and activate a virtual environment for Python packages
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Upgrade pip inside the virtual environment
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install pynvim

# Symlink pynvim so Neovim can find it
RUN ln -s /opt/venv/bin/pynvim /usr/local/bin/pynvim

# Install Neovim Node.js dependencies
RUN npm install -g neovim

# Install Neovim Plugin Manager (Lazy.nvim)
RUN mkdir -p /root/.config/nvim && git clone --depth 1 https://github.com/folke/lazy.nvim /root/.config/nvim/lazy.nvim

# Copy Configuration
COPY init.lua /root/.config/nvim/init.lua
COPY lua /root/.config/nvim/lua/

# Set default shell to bash
CMD ["/bin/bash"]
