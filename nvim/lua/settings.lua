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

