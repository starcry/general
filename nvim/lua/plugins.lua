-- Plugin Management (Lazy.nvim)
require("lazy").setup({
  -- === MAGIC PACK ===
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
      }
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
  },
  -- === END MAGIC PACK ===
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" }, -- Load lazily
    config = function()
      require("gitsigns").setup({
        current_line_blame = true,
        current_line_blame_opts = {
          delay = 1000,
          virt_text_pos = "eol",
        },
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      })

      -- Keybinding: show full git blame info for the current line
      vim.keymap.set("n", "<leader>gb", function()
        require("gitsigns").blame_line({ full = true })
      end, { desc = "Git Blame Line" })

      -- Optional: toggle inline blame
      vim.keymap.set("n", "<leader>tb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle Git Blame" })
    end,
  },
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
  { "L3MON4D3/LuaSnip" },
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
        "<C-j>",
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
    "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  },
  {
    "neovim/nvim-lspconfig"  -- LSP configurations
  },

  -- 2. zbirenbaum/copilot.lua (the alternative Copilot client)
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      -- you already have these elsewhere, but listing plenary is harmless
      { "nvim-lua/plenary.nvim", branch = "master" },
      -- you do NOT need to list "github/copilot.vim" here because
      -- you already have it as a top-level plugin spec above
    },
    build = "make tiktoken",  -- optional but recommended on macOS/Linux
    opts = {
      -- See :h CopilotChat or the README for options
    },
  },
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
        automatic_installation = { exclude = {} },
      })
    end
  },
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = true
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
        view = {
          merge_tool = {
            layout = "diff3_mixed", -- or "diff3_vertical" if you prefer side-by-side
            disable_diagnostics = true, -- turn off LSP warnings in merge view
          },
        },
      })
    end,
  },
  {
    "rmagatti/auto-session",
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { "<leader>wr", "<cmd>AutoSession search<CR>", desc = "Session search" },
      { "<leader>ws", "<cmd>AutoSession save<CR>", desc = "Save session" },
      { "<leader>wt", "<cmd>AutoSession toggle<CR>", desc = "Toggle session" },
      { "<leader>wd", "<cmd>AutoSession delete<CR>", desc = "Wipe current session" },
      { "<leader>wl", "<cmd>AutoSession restore<CR>", desc = "Load previous session" },
    },
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      auto_save = false,
      auto_restore = true,
      suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      -- log_level = 'debug',
    },
  },
}, {
  defaults = {
    lazy = false,  -- Load everything immediately
  },
  change_detection = {
    enabled = false,  -- Don’t auto-reload plugins
    notify = false,
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

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-q>"] = actions.send_to_qflist,
      },
    },
  },
})

-- Enable fzf-native if installed
pcall(telescope.load_extension, "fzf")

local builtin = require("telescope.builtin")

vim.api.nvim_create_user_command("GitGrepRoot", function()
  builtin.git_grep({ cwd = vim.fn.systemlist("git rev-parse --show-toplevel")[1] })
end, {})


