```md
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
- **Multiple LSPs**: Preconfigured for Terraform, YAML, Helm, Bash, Ansible, Docker, plus standard defaults.
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
   - **both**: Official GitHub Copilot inline suggestions **and** standard LSP completions from nvim-cmp.

2. **Treesitter** for better syntax highlighting, incremental parsing, and code structure.

3. **LSP Servers** for Terraform, Ansible, Bash, Dockerfile, YAML, Helm, etc.

4. **Snippet Engine** with [LuaSnip](https://github.com/L3MON4D3/LuaSnip) and sample Terraform snippets (`lua/snippets/terraform.lua`).

5. **nvim-tree** file explorer automatically opens on start.

6. **Lazy.nvim** plugin manager, easy updates and lazy-loading of plugins.

---

## Installation

1. **Install Neovim 0.8+**  
   - Check out [neovim.io](https://neovim.io) or use your system package manager.

2. **Install Required Dependencies** for your LSPs (where applicable):
   - **Node.js & npm** (for Bash, YAML, Dockerfile, Helm language servers).
   - **Python3 & pip** (for Ansible language server, ansible-lint).
   - **Terraform** + [terraform-ls](https://github.com/hashicorp/terraform-ls) if you want Terraform support.
   - **Luarocks** (optional, if you need `jsregexp` for LuaSnip’s advanced regex).

3. **Clone or Copy** this config into your Neovim folder:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```
   Make sure files are placed so that:
   ```
   ~/.config/nvim/init.lua
   ~/.config/nvim/lua/...
   ```

4. **Open Neovim**:
   ```bash
   nvim
   ```
   Lazy.nvim will prompt to install missing plugins the first time you open Neovim.

5. **Install & Sync Plugins**:
   ```vim
   :Lazy sync
   ```
   This installs all plugins. If you’re missing language servers, install them globally:
   ```bash
   npm install -g bash-language-server yaml-language-server dockerfile-language-server-nodejs @microsoft/helm-ls
   pip install ansible ansible-lint
   brew install terraform-ls  # or another method for your OS
   ```

---

## Copilot Modes

Open **`init.lua`** and change:
```lua
vim.g.copilot_mode = "both"
-- Possible values:
--   "disabled" => No Copilot at all; only nvim-cmp LSP completions
--   "native"   => Official GitHub Copilot inline suggestions only
--   "cmp"      => Copilot suggestions in the nvim-cmp popup
--   "both"     => Inline GitHub Copilot plus nvim-cmp completions
```
After changing this value, **save & restart Neovim** to apply.

---

## Key Plugins & Configuration Highlights

1. **[Lazy.nvim](https://github.com/folke/lazy.nvim)** – plugin manager (`lua/plugins.lua`).
2. **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** – LSP for Terraform (`terraform-ls`), Ansible, Bash, Docker, YAML, Helm, etc.
3. **[github/copilot.vim](https://github.com/github/copilot.vim)** – used in “native” or “both” mode for inline Copilot suggestions.  
   - Remapped `<C-l>` as the accept key (instead of `<Tab>`).
4. **[zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)** + **[copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)** – used in “cmp” mode to feed Copilot suggestions into nvim-cmp (no inline ghost text).
5. **[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** – autocompletion framework (LSP, buffer, path, etc.).
6. **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** – snippet engine (sample Terraform snippets in `lua/snippets/terraform.lua`).
7. **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** – improved syntax highlighting & structure.
8. **[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)** – file explorer, auto-opens on start.
9. **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** – status line.

---

## Usage

1. **Launch Neovim**:
   ```bash
   nvim
   ```
2. **Check or Update Plugins**:
   ```vim
   :Lazy sync
   ```
3. **Switch Copilot Mode** in `init.lua`:
   ```lua
   vim.g.copilot_mode = "native"
   ```
   Then **restart** Neovim for changes to take effect.

4. **Test LSP & Copilot**:
   - Open a file (like `main.tf`) to check LSP functionalities (hover, go-to-definition, etc.).
   - If in “native” or “both” mode, Copilot inline suggestions appear as ghost text.  
     - Press `<C-l>` to accept.
   - If in “cmp” mode, Copilot completions appear in the nvim-cmp popup.  
     - Use `<Tab>` or `<CR>` to select them.

5. **Keymaps**:
   - `<leader>e` toggles the file explorer (nvim-tree).
   - `[d` / `]d` jump to previous/next diagnostic.
   - `<leader>E` opens the floating diagnostic window.
   - `<leader>q` sends diagnostics to the location list.

---

## Credits

- **[Lazy.nvim](https://github.com/folke/lazy.nvim)** by [@folke](https://github.com/folke)
- **[github/copilot.vim](https://github.com/github/copilot.vim)** by GitHub
- **[zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua)** & **[copilot-cmp](https://github.com/zbirenbaum/copilot-cmp)**
- **[hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp)** & related cmp sources
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** for LSP integration
- **[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua)** / **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** / **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)** / **[lualine](https://github.com/nvim-lualine/lualine.nvim)**
- And language servers: **terraform-ls**, **ansible-language-server**, **bash-language-server**, **docker-langserver**, **yaml-language-server**, **helm-ls**.

Enjoy your enhanced Neovim setup! If you have any questions, feel free to open an issue or reach out.
```
