-- Plugin Management (Lazy.nvim)
require("lazy").setup({
  -- LSP Support
  {"neovim/nvim-lspconfig"},

  -- Terraform Language Server & Syntax Highlighting
  {"hashivim/vim-terraform"},

--  -- Autocompletion

  -- 4. nvim-cmp and related completion plugins
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    enabled = function()
      -- We want nvim-cmp in TWO modes:
      --  - "disabled" => normal LSP completions only
      --  - "cmp"      => LSP + Copilot via cmp
      -- We do NOT load nvim-cmp if we want purely "native" Copilot
      return vim.g.copilot_mode ~= "native"
    end,
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Build a base sources table
      local sources = {
        { name = "nvim_lsp" },--, group_index = 2 },
        { name = "luasnip" },--,  group_index = 2 },
        { name = "path" },--,     group_index = 2 },
        { name = "buffer" },--,   group_index = 2 },
      }

      -- If we’re in "cmp" mode, also enable the Copilot source
      if vim.g.copilot_mode == "cmp" then
        table.insert(sources, { name = "copilot", group_index = 2 })
      end

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = {
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = sources,
      })
    end
  },
--  {
--    "hrsh7th/nvim-cmp",
--    enabled = function()
--      -- Toggle logic: If Copilot is disabled, we want full CMP
--      return not vim.g.enable_copilot
--    end,
--    dependencies = {
--      { "hrsh7th/cmp-nvim-lsp",   enabled = function() return not vim.g.enable_copilot end },
--      { "hrsh7th/cmp-buffer",     enabled = function() return not vim.g.enable_copilot end },
--      { "hrsh7th/cmp-path",       enabled = function() return not vim.g.enable_copilot end },
--      { "saadparwaiz1/cmp_luasnip", enabled = function() return not vim.g.enable_copilot end },
--      { "L3MON4D3/LuaSnip" }, -- you can keep LuaSnip around all the time if you want
--    },
--    config = function()
--      local cmp = require("cmp")
--      local luasnip = require("luasnip")
--      cmp.setup({
--        snippet = {
--          expand = function(args) luasnip.lsp_expand(args.body) end,
--        },
--        mapping = {
--          ["<Tab>"] = cmp.mapping.select_next_item(),
--          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
--          ["<CR>"] = cmp.mapping.confirm({ select = true }),
--        },
--        sources = cmp.config.sources({
--          { name = "luasnip" },
--          { name = "nvim_lsp" },
--          { name = "buffer" },
--          { name = "path" },
--          { name = "cmdline" },
--        }),
--      })
--    end
--  },

--  {"hrsh7th/nvim-cmp"},
--  {"hrsh7th/cmp-nvim-lsp"},
--  {"hrsh7th/cmp-buffer"},
--  {"hrsh7th/cmp-path"},

  -- Snippet Engine & Snippets
--  {"L3MON4D3/LuaSnip"},
--  {"saadparwaiz1/cmp_luasnip"},

  -- Treesitter (Better Syntax Highlighting & Indentation)
  {
    "nvim-treesitter/nvim-treesitter", opts = {
      ensure_installed = { "lua", "bash", "terraform", "yaml", "dockerfile" },
      highlight = { enable = true },
      indent = { enable = true }
    }
  },

  -- UI Enhancements (File Explorer)
--  {"nvim-tree/nvim-tree.lua"},
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {"nvim-tree/nvim-web-devicons"}, -- Dependency for nvim-tree
  { "nvim-treesitter/playground" },
  {
    "L3MON4D3/LuaSnip",
    build = function()
      vim.cmd("!make install_jsregexp")
    end
  },
--  { "github/copilot.vim" },
  {
    "github/copilot.vim",
    enabled = function()
      return vim.g.copilot_mode == "native"
    end
  },
  {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true
      -- use opts = {} for passing setup options
      -- this is equivalent to setup({}) function
  },
  {
    'rmagatti/auto-session',
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
    }
  },
--  {
--    'nvim-lualine/lualine.nvim',
--    dependencies = { 'nvim-tree/nvim-web-devicons' }
--  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        sections = {
          lualine_c = { { 'filename', path = 2 } }
        }
      })
    end
  },
  {
  "towolf/vim-helm", ft = "helm"  -- Helm syntax highlighting
  },
  {
    "neovim/nvim-lspconfig"  -- LSP configurations
  },
--  {
--    "zbirenbaum/copilot-cmp",
--    config = function ()
--      require("copilot_cmp").setup()
--    end
--  }

  -- 2. zbirenbaum/copilot.lua (the alternative Copilot client)
  {
    "zbirenbaum/copilot.lua",
    enabled = function()
      return vim.g.copilot_mode == "cmp"
    end,
    config = function()
      require("copilot").setup({
        -- we disable Copilot’s inline suggestion/panel
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end
  },

  -- 3. zbirenbaum/copilot-cmp (turn Copilot into a cmp source)
  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "zbirenbaum/copilot.lua" },
    enabled = function()
      return vim.g.copilot_mode == "cmp"
    end,
    config = function ()
      require("copilot_cmp").setup()
    end
  }
})

require('lualine').setup({
  sections = {
    lualine_c = { { 'filename', path = 2 } } -- 1 = Relative Path, 2 = Absolute Path
  }
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "yaml", "json", "bash" },
  highlight = { enable = true },
  indent = { enable = true },
})

