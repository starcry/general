# Neovim Configuration with Multiple Copilot Modes & LSP

This Neovim configuration provides a flexible setup for multiple Copilot modes, integrated LSP servers (for Terraform, Ansible, Bash, Docker, YAML, etc.), Treesitter, snippet support, and more—using [Lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.

## Table of Contents
1. [Overview](#overview)
2. [Features](#features)
3. [Installation](#installation)
4. [Copilot Modes](#copilot-modes)
5. [Key Plugins & Configuration Highlights](#key-plugins--configuration-highlights)
6. [Usage](#usage)
7. [Credits](#credits)

---

## Overview

- **Neovim version**: Requires at least Neovim 0.8.
- **Plugin Manager**: [Lazy.nvim](https://github.com/folke/lazy.nvim).
- **Copilot**: Supports both the official `github/copilot.vim` plugin (inline suggestions) and the alternative [`copilot.lua`](https://github.com/zbirenbaum/copilot.lua) + [`copilot-cmp`](https://github.com/zbirenbaum/copilot-cmp) for integration into `nvim-cmp`.
- **Multiple LSPs** configured: Terraform, YAML, Helm, Bash, Ansible, Docker, plus standard defaults.
- **Treesitter**-powered syntax highlighting and code structure awareness.
- **LuaSnip** for snippets (sample Terraform snippets included).
- **nvim-tree** for file browsing, auto-opens at startup.
- **Lualine** as a status line.

This configuration is set up so you can easily **toggle** between different Copilot modes or disable Copilot entirely.

---

## Features

1. **Multiple Copilot Modes**:
   - **disabled**: Only nvim-cmp (for LSP, buffer, path completions), no Copilot.
   - **native**: Official GitHub Copilot inline suggestions only.
   - **cmp**: Copilot suggestions appear in the nvim-cmp menu (no inline ghost text).
   - **both**: Official GitHub Copilot inline suggestions **and** regular LSP completions from nvim-cmp.

2. **Treesitter** for better syntax highlighting, incremental parsing, and code structure awareness.

3. **LSP servers** for Terraform, Ansible, Bash, Dockerfile, YAML, Helm, etc.

4. **Snippet Engine** with [LuaSnip](https://github.com/L3MON4D3/LuaSnip) and sample Terraform snippets (`lua/snippets/terraform.lua`).

5. **nvim-tree** file explorer automatically opens on start.

6. **Lazy.nvim** plugin manager, easy updates and lazy-loading of plugins.

---

## Installation

1. **Install Neovim 0.8+** (via your package manager or from [neovim.io](https://neovim.io)).
2. **Install Required Dependencies**:
   - **Node.js** & **npm** for installing language servers like `bash-language-server`, `yaml-language-server`, etc.
   - **Python3** & `pip` for Ansible, ansible-lint, etc.
   - **Terraform** & [terraform-ls](https://github.com/hashicorp/terraform-ls) if using Terraform.
   - **Optional**: [luarocks](https://luarocks.org/) for installing `jsregexp` used by LuaSnip’s advanced regex features.
3. **Install or Clone** this Neovim config into `~/.config/nvim` (or the corresponding config directory on your system). The structure should look like:
