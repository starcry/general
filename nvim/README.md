# ✨ Neovim "Magic" Configuration

Welcome to your advanced Neovim setup! This configuration is built for speed, aesthetics, and power, leveraging **Lazy.nvim** for lightning-fast startup times and a suite of "Magic" plugins to enhance your workflow.

## 🚀 Quick Start

1.  **Docs**: Press `<leader>h` inside Neovim to see your **Keymaps Cheat Sheet**.
2.  **Update**: Run `:Lazy sync` to update all plugins and Mason packages.
3.  **Health**: Run `:checkhealth` if something feels wrong.

---

## 📚 The "Magic" Plugin Directory

This configuration relies on these powerful plugins. Click the links to read their full documentation for advanced commands and configuration options.

### 🧠 Core & Package Management
*   **[Lazy.nvim](https://github.com/folke/lazy.nvim)**: The modern plugin manager powering this config.
*   **[Mason.nvim](https://github.com/williamboman/mason.nvim)**: Portable package manager for LSPs, DAPs, linters, and formatters.
    *   *Related*: `williamboman/mason-lspconfig.nvim`, `jay-babu/mason-nvim-dap.nvim`.

### 🎨 UI & Aesthetics
*   **[Noice.nvim](https://github.com/folke/noice.nvim)**: Replaces the UI for messages, cmdline, and popupmenu with fancy animations.
*   **[Nvim-Notify](https://github.com/rcarriga/nvim-notify)**: Beautiful notification manager.
*   **[Lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: The blazing fast statusline at the bottom of your screen.
*   **[Nvim-Tree](https://github.com/nvim-tree/nvim-tree.lua)**: A file explorer tree (`<leader>e`).
*   **[Oil.nvim](https://github.com/stevearc/oil.nvim)**: Edit your filesystem like a normal buffer (`-`).
*   **[Nvim-Web-Devicons](https://github.com/nvim-tree/nvim-web-devicons)**: Adds file type icons to your plugins.

### 🧭 Navigation & Fuzzy Finding
*   **[Telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: The highly extendable fuzzy finder over lists.
*   **[Harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2)**: Blazing fast file navigation for your "working set" of files.
*   **[Flash.nvim](https://github.com/folke/flash.nvim)**: Navigate your code with search labels (like EasyMotion but faster).

### 💻 Coding, LSP & Completion
*   **[Nvim-LSPConfig](https://github.com/neovim/nvim-lspconfig)**: Quickstart configs for Neovim LSP.
*   **[Nvim-Cmp](https://github.com/hrsh7th/nvim-cmp)**: The auto-completion engine.
    *   *Sources*: `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp-luasnip`.
*   **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)**: Snippet engine.
*   **[Nvim-Surround](https://github.com/kylechui/nvim-surround)**: Add/change/delete surrounding delimiter pairs with ease (e.g. `ysiw"`).
*   **[Nvim-Autopairs](https://github.com/windwp/nvim-autopairs)**: Autopairs for neovim written in Lua.
*   **[Nvim-DAP](https://github.com/mfussenegger/nvim-dap)**: Debug Adapter Protocol client (Debugging).
*   **[SchemaStore.nvim](https://github.com/b0o/schemastore.nvim)**: JSON schemas for autocompletion.

### 🌳 Git Integration
*   **[Gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: Git integration for buffers (signs in gutter, blame line).
*   **[Neogit](https://github.com/NeogitOrg/neogit)**: A Magit clone for Neovim.
*   **[Diffview.nvim](https://github.com/sindrets/diffview.nvim)**: Single tabpage interface for easily cycling through diffs.
*   **[Auto-Session](https://github.com/rmagatti/auto-session)**: Automated session manager (`<leader>ws`, `<leader>wr`).

### 🤖 AI Assistance
*   **[Copilot.vim](https://github.com/github/copilot.vim)**: Official GitHub Copilot plugin (Ghost text).
*   **[Copilot.lua](https://github.com/zbirenbaum/copilot.lua)**: Pure Lua alternative for Copilot.
*   **[CopilotChat.nvim](https://github.com/CopilotC-Nvim/CopilotChat.nvim)**: Chat with Copilot in Neovim (`<leader>aa`).

### 🌲 Syntax Highlighting
*   **[Nvim-Treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Treesitter configurations and abstraction layer.

---

## 🍳 The Cookbook

Features that don't have dedicated keymaps but are useful to know.

### 📦 Managing Plugins & Tools
*   **Update Plugins**: `:Lazy sync`
*   **Check Plugin Status**: `:Lazy home`
*   **Install New Tool (LSP/Linter)**: `:Mason` -> Use arrow keys and `<CR>` to install/update tools.

### 🕵️ Telescope Power User
Telescope can do almost anything. Here are some commands to run directly (`:Telescope <command>`):
*   `commands`: Search and run Neovim commands.
*   `keymaps`: Search normal mode keymappings.
*   `man_pages`: Search man pages.
*   `colorscheme`: Preview and switch colorschemes.
*   `resume`: Open the last picker with the same search results.

### ⚡ Flash Navigation
Flash is installed but often forgotten.
*   **Jump to any word**: Press `s` (in normal/visual mode) then type two characters of the word you want to jump to. Labels will appear.
*   **Treesitter Select**: Press `S` to visually select a Treesitter node (like a function or if-block).

### 🪵 Git Magic
*   **Full Magit Experience**: Run `:Neogit` to open a full git status window where you can stage hunks (`s`), commit (`c`), push (`P`), etc.
*   **Detailed History**: `:DiffviewFileHistory` shows the history of the current file.
*   **Resolve Conflicts**: `:DiffviewOpen` opens a 3-way merge view.

### SESSION MANAGEMENT
*   **Switch Project**: `<leader>wr` (Search Sessions)
*   **Save Current**: `<leader>ws`
*   **Wipe Current**: `<leader>wd`
*   **Toggle Auto-Save**: `<leader>wt`

### 🔭 Copilot
*   **Inline Suggestion**: Press `<C-l>` to accept a suggestion.
*   **Chat**: `<leader>aa` to open the chat window.
*   **Explain Code**: Select code visually, then run `:CopilotChatExplain`.
