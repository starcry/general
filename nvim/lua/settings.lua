vim.o.confirm = true  -- Prompts instead of discarding unsaved changes

-- Mouse Behavior
vim.opt.mouse = "nv"  -- Allow scrolling in Normal & Visual, but disable clicks

-- update to whatever which python shows
vim.g.python3_host_prog = "/opt/venv/bin/python"

-- disabling support for things we don't need
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Enable line numbers
vim.opt.number = true

-- Disable text wrapping
vim.opt.wrap = false

-- Make line numbers brighter
vim.cmd("highlight LineNr guifg=#00ffdc")  -- Adjust color to your preference

-- 🧨 Kill all forms of history/caching
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.shadafile = "NONE"
vim.opt.directory = "/tmp"  -- If anything leaks, it's gone on reboot

-- 🔍 Show trailing whitespace
vim.opt.list = true
vim.opt.listchars:append({ trail = "·" })

-- Optional: visually highlight trailing whitespace too (even if invisible chars are off)
vim.cmd [[highlight ExtraWhitespace ctermbg=red guibg=red]]

-- Automatically apply that highlight to all open buffers
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufReadPost" }, {
  pattern = "*",
  callback = function()
    vim.cmd [[match ExtraWhitespace /\s\+$/]]
  end,
})
