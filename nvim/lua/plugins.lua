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

  -- Treesitter (Better Syntax Highlighting & Indentation)
  {
    "nvim-treesitter/nvim-treesitter", opts = {
      ensure_installed = { "lua", "bash", "terraform", "yaml", "dockerfile", "go", "json" },
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
      return vim.g.copilot_mode == "native" or (vim.g.copilot_mode == "both")
    end,
    config = function()
      -- OPTIONAL: override the default Copilot <Tab> acceptance
      -- so it doesn’t conflict with nvim-cmp
      vim.g.copilot_no_tab_map = true
      vim.api.nvim_set_keymap(
        "i",
        "<C-l>",
        'copilot#Accept("<CR>")',
        { silent = true, expr = true, noremap = true }
      )
      -- Now inline Copilot suggestions accept with <C-l>
      -- and won't steal <Tab> from nvim-cmp
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
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui", "jay-babu/mason-nvim-dap.nvim" },
    config = function()
      local dap = require("dap")

      dap.adapters.coreclr = {
        type = "executable",
        command = "netcoredbg",
        args = { "--interpreter=vscode" }
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          request = "launch",
          name = "Launch",
          program = function()
            return vim.fn.input('Path to DLL: ', vim.fn.getcwd() .. '/bin/Debug/net7.0/', 'file')
          end,
        }
      }
    end
  },
	{"b0o/schemastore.nvim"},
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate", -- This will update mason when you run :Lazy sync
    config = function()
      require("mason").setup({
        -- (optional) custom mason settings here
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
				ensure_installed = { "omnisharp", "bashls", "jsonls", "gopls" },
				automatic_installation = true,
      })
    end
  },
})

require('lualine').setup({
  sections = {
    lualine_c = { { 'filename', path = 2 } } -- 1 = Relative Path, 2 = Absolute Path
  }
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "yaml", "json", "bash", "go", "lua", "dockerfile", "terraform" },
  highlight = { enable = true },
  indent = { enable = true },
})

