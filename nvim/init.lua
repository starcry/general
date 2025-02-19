vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.enable_copilot = false

-- Bootstrap Lazy.nvim
require("bootstrap")
require("plugins")
require("lsp")
require("keymaps")
require("settings")
require("ui")
require("copilot")
require("treesitter")




-- Setup Auto-Completion
--local cmp = require("cmp")

--cmp.setup({
--  snippet = {
--    expand = function(args)
--      require("luasnip").lsp_expand(args.body)
--    end,
--  },
--  mapping = {
--    ["<Tab>"] = cmp.mapping.select_next_item(),
--    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
--    ["<CR>"] = cmp.mapping.confirm({ select = true }),
--  },
--  sources = cmp.config.sources({
--    { name = "luasnip" },
--    { name = "nvim_lsp" },
--    { name = "buffer" },
--    { name = "path" },
--    { name = "cmdline" }, -- Enables autocompletion for shell commands
--  }),
--})

-- Load LuaSnip Snippets
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/snippets/" })

--vim.o.statusline = "%F %m %r %h %w [%{&fileformat}] [%{&fileencoding}] [%Y] [%p%%]"
-- Show a red vertical line at column 80
vim.o.colorcolumn = "80"

-- Highlight the cursor line and cursor column
vim.o.cursorline = true
vim.o.cursorcolumn = true


