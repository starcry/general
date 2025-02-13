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
  {
    "nvim-treesitter/nvim-treesitter", opts = {
      ensure_installed = { "lua", "bash", "terraform", "yaml" },
      highlight = { enable = true },
      indent = { enable = true }
    }
  },

  -- UI Enhancements (File Explorer)
  {"nvim-tree/nvim-tree.lua"},
  {"nvim-tree/nvim-web-devicons"}, -- Dependency for nvim-tree
  {
    "L3MON4D3/LuaSnip",
    build = function()
      vim.cmd("!make install_jsregexp")
    end
  },
  { "github/copilot.vim" },
  {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
  }
})
