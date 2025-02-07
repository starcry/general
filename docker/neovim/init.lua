vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Bootstrap Lazy.nvim
require("bootstrap")
require("plugins")
require("lsp")
require("keymaps")
require("settings")



-- Load nvim-tree on startup
require("nvim-tree").setup()

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


----------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------
