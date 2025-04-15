-- Keybinding to Toggle File Explorer (NvimTree)
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>r", ":NvimTreeRefresh<CR>", { noremap = true, silent = true })

-- Diagnostic Navigation (Floating Window, Previous/Next, List)
vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float) -- Capital E to avoid conflict with NvimTree
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev) -- Jump to previous diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next) -- Jump to next diagnostic
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist) -- Add diagnostics to location list

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

  end,
})
