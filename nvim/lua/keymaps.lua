-- Show KEYMAPS.md in a centered floating window
local function show_keymaps_float()
  local readme = vim.fn.stdpath("config") .. "/KEYMAPS.md"
  if vim.fn.filereadable(readme) == 0 then
    vim.notify("KEYMAPS.md not found at " .. readme, vim.log.levels.ERROR)
    return
  end

  local lines = vim.fn.readfile(readme)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false

  local ui = vim.api.nvim_list_uis()[1]
  local width  = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.7)
  local row    = math.floor((ui.height - height) / 2)
  local col    = math.floor((ui.width - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
    title = " Keymaps ",
    title_pos = "center",
  })

  -- quick close with q or <Esc>
  vim.keymap.set("n", "q", function() pcall(vim.api.nvim_win_close, win, true) end, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", function() pcall(vim.api.nvim_win_close, win, true) end, { buffer = buf, nowait = true })
end

vim.keymap.set("n", "<leader>h", show_keymaps_float, { desc = "Show Keymaps (float)" })

-- enter conflict resolution mode
--vim.keymap.set("n", "<leader>gi", ":DiffviewOpen<CR>", { desc = "Open Git diff view" })
-- Toggle Diffview on <leader>gi
vim.keymap.set("n", "<leader>gi", function()
  local ok, diffview = pcall(require, "diffview")
  if not ok then
    vim.notify("diffview.nvim not installed", vim.log.levels.ERROR)
    return
  end

  local lib = require("diffview.lib")
  local view = lib.get_current_view()
  if view then
    diffview.close()
  else
    diffview.open()  -- you can pass args here, e.g. diffview.open({}) or "HEAD~1"
  end
end, { desc = "Toggle Diffview" })

-- Take "ours" for current conflict
vim.keymap.set("n", "<leader>go", ":diffget //2<CR>", { desc = "Take ours" })
--vim.keymap.set("n", "<leader>go", "<cmd>diffget LOCAL<CR>", { desc = "Take ours (LOCAL)" })
-- Take "theirs" for current conflict
vim.keymap.set("n", "<leader>gt", ":diffget //3<CR>", { desc = "Take theirs" })
--vim.keymap.set("n", "<leader>gt", "<cmd>diffget THEIRS<CR>", { desc = "Take theirs (THEIRS)" })
-- Delete entire conflict
-- Delete the whole conflict region under the cursor
vim.keymap.set("n", "<leader>gd", function()
  local start_pat = "^<<<<<<<"
  local mid_pat   = "^======="
  local end_pat   = "^>>>>>>>"

  -- Find the start of the conflict (searching upwards)
  local start = vim.fn.search(start_pat, "bnW")
  if start == 0 then
    vim.notify("No conflict start found above cursor", vim.log.levels.WARN)
    return
  end

  -- Find the end of the conflict (searching downwards)
  local finish = vim.fn.search(end_pat, "nW")
  if finish == 0 then
    vim.notify("No conflict end found below cursor", vim.log.levels.WARN)
    return
  end

  -- Delete everything between start and finish (inclusive)
  vim.api.nvim_buf_set_lines(0, start - 1, finish, false, {})

  vim.notify("Conflict region deleted", vim.log.levels.INFO)
end, { desc = "Delete merge conflict region" })

-- Keybinding to Toggle File Explorer (NvimTree)
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", { noremap = true, silent = true })

-- Diagnostic Navigation (Floating Window, Previous/Next, List)
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float) -- Capital E to avoid conflict with NvimTree
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev) -- Jump to previous diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next) -- Jump to next diagnostic
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist) -- Add diagnostics to location list

-- Yank to system clipboard
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line to system clipboard" })
vim.keymap.set("n", "<leader>ya", ":%y+<CR>", { desc = "Yank entire file to system clipboard" })

-- Cut (delete) to system clipboard
vim.keymap.set({ "n", "x" }, "<leader>d", '"+d', { desc = "Cut to system clipboard" })
vim.keymap.set("n", "<leader>D", '"+D', { desc = "Cut line to system clipboard" })

-- Paste from system clipboard
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from system clipboard (after cursor)" })
vim.keymap.set({ "n", "x" }, "<leader>P", '"+P', { desc = "Paste from system clipboard (before cursor)" })

-- Prevent Mouse Clicks from Moving Cursor
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.cmd("nnoremap <LeftMouse> :<C-U>echo 'Mouse Click Disabled'<CR>")
  end,
})

-- Use LspAttach autocommand to only map keys after an LSP server attaches
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }

    -- LSP Actions
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- Go to definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts) -- Go to declaration
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts) -- Go to implementation
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- Show function signature
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts) -- Show hover info
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts) -- Show references

    -- Workspace Management
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts) -- Add workspace folder
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts) -- Remove workspace folder
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts) -- List workspace folders

    -- Code Actions & Formatting
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts) -- Show code actions
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts) -- Rename symbol
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts) -- Format file

    -- Type Definitions & Symbols
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts) -- Go to type definition

    -- Debugging
    vim.keymap.set('n', '<F5>', function() require('dap').continue() end, opts)
    vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, opts)
    vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, opts)
    vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, opts)
    vim.keymap.set('n', '<leader>b', function() require('dap').toggle_breakpoint() end, opts)
    vim.keymap.set('n', '<leader>B', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts)

    -- Trailing space shortcuts
    vim.keymap.set("n", "]t", "/\\s\\+$<CR>", { desc = "Next trailing space" })
    vim.keymap.set("n", "[t", "?\\s\\+$<CR>", { desc = "Previous trailing space" })
    vim.keymap.set("n", "<leader>tl", [[:s/\s\+$//<CR>]], { desc = "Trim trailing spaces (line)" })
    vim.keymap.set("n", "<leader>tf", [[:%s/\s\+$//e<CR>]], { desc = "Trim trailing spaces (file)" })

    -- Copilot Chat
    vim.keymap.set({ "n", "v" }, "<leader>aa", function()
      require("CopilotChat").toggle()
    end, { desc = "Toggle Copilot Chat" })

    -- Copilot shortcuts
    vim.keymap.set("n", "<leader>ha", function()
      require("copilot-chat.panel").accept() -- inserts the currently selected suggestion
    end, { desc = "Copilot Chat: Accept suggestion" })

--    vim.keymap.set("n", "<leader>hp", ":Copilot panel<CR>", { desc = "Copilot Panel" })
--    vim.keymap.set("n", "<leader>ha", ":CopilotAction<CR>", { desc = "Copilot Action" })
--    vim.keymap.set("i", "<C-l>", 'copilot#Accept("")', {
--      expr = true,
--      replace_keycodes = false,
--      desc = "Copilot Accept",
--    })

  end,
})

