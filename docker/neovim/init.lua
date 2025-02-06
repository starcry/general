vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Install Lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin Management (Lazy.nvim)
require("lazy").setup({
  -- LSP Support
  {"neovim/nvim-lspconfig"},

  -- Terraform Language Server & Syntax Highlighting
  {"hashivim/vim-terraform"},

  -- Autocompletion
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"hrsh7th/cmp-buffer"},
  {"hrsh7th/cmp-path"},

  -- Snippet Engine & Snippets
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},

  -- Treesitter (Better Syntax Highlighting & Indentation)
  {"nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "lua", "bash", "terraform" }, highlight = { enable = true }, indent = { enable = true }}},

  -- UI Enhancements (File Explorer)
  {"nvim-tree/nvim-tree.lua"},
  {"nvim-tree/nvim-web-devicons"}, -- Dependency for nvim-tree
})

-- LSP Configuration
local lspconfig = require("lspconfig")

lspconfig.terraformls.setup({
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  autostart = true,
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false  -- Disable autoformat
  end,
})

-- Load nvim-tree on startup
require("nvim-tree").setup()

-- Keybinding to Toggle File Explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Auto-open File Tree when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

-- Setup Auto-Completion
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Load LuaSnip Snippets
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })

-- Mouse Behavior
vim.opt.mouse = "nv"  -- Allow scrolling in Normal & Visual, but disable clicks

-- Prevent Mouse Clicks from Moving Cursor
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("nnoremap <LeftMouse> :<C-U>echo 'Mouse Click Disabled'<CR>")
  end,
})
