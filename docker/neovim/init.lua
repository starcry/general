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

-- Plugin management with Lazy.nvim
require("lazy").setup({
  -- LSP Support
  {"neovim/nvim-lspconfig"},

  -- Terraform Language Server
  {"hashivim/vim-terraform"},

  -- Autocompletion
  {"hrsh7th/nvim-cmp"},  -- Core autocompletion engine
  {"hrsh7th/cmp-nvim-lsp"},  -- LSP source for cmp
  {"hrsh7th/cmp-buffer"},  -- Buffer completion
  {"hrsh7th/cmp-path"},  -- Path completion

  -- Snippet Engine
  {"L3MON4D3/LuaSnip"},
  {"saadparwaiz1/cmp_luasnip"},  -- Snippets source for cmp

  -- Treesitter for better syntax highlighting
  {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"},

  -- File Explorer (NERDTree alternative)
  {"nvim-tree/nvim-tree.lua"},

  -- Dependency for nvim-tree
  {"nvim-tree/nvim-web-devicons"}, 
})

local lspconfig = require("lspconfig")

-- Configure Terraform LSP for error reporting (without autoformat)
lspconfig.terraformls.setup({
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  autostart = true,  
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
  end,
})

-- Load nvim-tree on startup
require("nvim-tree").setup()

-- Keybinding to toggle file explorer
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Auto-open file tree when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "bash", "terraform" },  -- Install these parsers
  highlight = { enable = true },
  indent = { enable = true }
})

local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),  -- Tab for next suggestion
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),  -- Shift+Tab for previous suggestion
    ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Enter to confirm
  },
  sources = {
    { name = "nvim_lsp" },  -- Use LSP for auto-completion
    { name = "buffer" },  -- Suggest words from the current file
    { name = "path" },  -- Suggest file paths
  },
})

-- Load LuaSnip
local luasnip = require("luasnip")

-- Enable snippet expansion in completion
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = "luasnip" },  -- Enable snippets
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  }),
})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })

vim.opt.mouse = "nv"  -- Enable mouse for scrolling in Normal & Visual mode, but disable clicks

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("nnoremap <LeftMouse> :<C-U>echo 'Mouse Click Disabled'<CR>")
  end,
})

