vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.copilot_mode = "cmp"
-- Possible values:
-- "disabled" => no Copilot at all; only nvim-cmp with LSP
-- "native"   => official GitHub Copilot (github/copilot.vim) with inline suggestions
-- "cmp"      => Copilot via cmp (zbirenbaum/copilot.lua + copilot-cmp)

local valid_modes = {
  disabled = true,
  native   = true,
  cmp      = true,
}

if not valid_modes[vim.g.copilot_mode] then
  error("Invalid copilot_mode: " .. vim.g.copilot_mode ..
        ". Valid options are: 'disabled', 'native', or 'cmp'.")
end


-- Bootstrap Lazy.nvim
require("bootstrap")
require("plugins")
require("lsp")
require("keymaps")
require("settings")
require("ui")
require("copilot_native")
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


