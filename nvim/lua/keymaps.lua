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

-- === MAGIC PACK KEYMAPS ===

-- Harpoon
local harpoon_ok, harpoon = pcall(require, "harpoon")
if harpoon_ok then
  harpoon:setup()
  vim.keymap.set("n", "<leader>hb", function() harpoon:list():add() end, { desc = "Harpoon: Add file" })
  vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Menu" })

  vim.keymap.set("n", "<leader>ha", function() harpoon:list():select(1) end)
  vim.keymap.set("n", "<leader>hs", function() harpoon:list():select(2) end)
  vim.keymap.set("n", "<leader>hd", function() harpoon:list():select(3) end)
  vim.keymap.set("n", "<leader>hf", function() harpoon:list():select(4) end)
end


-- Oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Trouble
vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end, { desc = "Toggle Trouble" })
vim.keymap.set("n", "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, { desc = "Trouble Workspace Diagnostics" })
vim.keymap.set("n", "<leader>xd", function() require("trouble").toggle("document_diagnostics") end, { desc = "Trouble Document Diagnostics" })
vim.keymap.set("n", "<leader>xq", function() require("trouble").toggle("quickfix") end, { desc = "Trouble Quickfix" })
vim.keymap.set("n", "<leader>xl", function() require("trouble").toggle("loclist") end, { desc = "Trouble Loclist" })
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, { desc = "Trouble LSP References" })

-- Flash is configured in plugins.lua keys directly, but could be added here if needed.
-- === END MAGIC PACK KEYMAPS ===


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
-- ===== Merge conflict helpers (robust) =====

local function find_conflict_region(bufnr, cursor_line)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local n = #lines
  local cur = math.max(1, math.min(cursor_line, n))

  local start, mid, finish

  -- Scan upward for <<<<<<<
  for i = cur, 1, -1 do
    if lines[i]:match("^<<<<<<<") then
      start = i
      break
    end
  end
  if not start then return nil end

  -- Scan downward for ======= and >>>>>>>
  for i = start + 1, n do
    if (not mid) and lines[i]:match("^=======") then
      mid = i
    elseif lines[i]:match("^>>>>>>>") then
      finish = i
      break
    end
  end

  if not mid or not finish then return nil end
  if not (start < mid and mid < finish) then return nil end

  return start, mid, finish
end

local function resolve_conflict(choice)
  local bufnr = 0
  local cur = vim.fn.line(".")
  local start, mid, finish = find_conflict_region(bufnr, cur)
  if not start then
    vim.notify("No merge conflict found around cursor", vim.log.levels.WARN)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Extract ours/theirs (vim.list_slice uses 1-based inclusive indices)
  local ours   = vim.list_slice(lines, start + 1, mid - 1)
  local theirs = vim.list_slice(lines, mid + 1, finish - 1)

  local replacement = (choice == "ours") and ours or theirs

  -- Replace the whole conflict block in ONE operation.
  -- buf_set_lines end index is exclusive, so use finish (line number) as-is.
  vim.api.nvim_buf_set_lines(bufnr, start - 1, finish, false, replacement)

  vim.notify("Took " .. choice .. " for conflict", vim.log.levels.INFO)
end

-- Your requested mappings:
vim.keymap.set("n", "<leader>gmo", function() resolve_conflict("ours") end,   { desc = "Take ours (HEAD)" })
vim.keymap.set("n", "<leader>gmt", function() resolve_conflict("theirs") end, { desc = "Take theirs (incoming)" })

-- Optional: delete whole conflict region (keep nothing)
vim.keymap.set("n", "<leader>gd", function()
  local bufnr = 0
  local cur = vim.fn.line(".")
  local start, _, finish = find_conflict_region(bufnr, cur)
  if not start then
    vim.notify("No merge conflict found around cursor", vim.log.levels.WARN)
    return
  end
  vim.api.nvim_buf_set_lines(bufnr, start - 1, finish, false, {})
  vim.notify("Deleted conflict region", vim.log.levels.INFO)
end, { desc = "Delete merge conflict region" })

-- Jump to next/prev merge conflict marker
vim.keymap.set("n", "]m", function()
  vim.fn.search([[^\(<\{7}\|=\{7}\|>\{7}\)]], "W")
end, { desc = "Next merge conflict marker" })

vim.keymap.set("n", "[m", function()
  vim.fn.search([[^\(<\{7}\|=\{7}\|>\{7}\)]], "bW")
end, { desc = "Prev merge conflict marker" })

-- Telescope Git search (Tracked files only)
vim.keymap.set("n", "<leader>gg", function()
  require("telescope.builtin").live_grep({
    vimgrep_arguments = { "git", "grep", "-n", "--column" },
  })
end, { desc = "Git grep (tracked files only)" })

-- Grep word under cursor (Tracked files only)
vim.keymap.set("n", "<leader>gw", function()
  require("telescope.builtin").live_grep({
    vimgrep_arguments = { "git", "grep", "-n", "--column" },
    default_text = vim.fn.expand("<cword>"),
    initial_mode = "normal", -- Optional: start in normal mode if searching word? No, let's keep insert to edit.
  })
end, { desc = "Grep word under cursor (tracked)" })

vim.keymap.set("n", "<leader>gr", ":GitGrepRoot<CR>", { desc = "Git grep from repo root" })

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
    --vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts) -- Go to definition
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

--    -- Copilot shortcuts
--    vim.keymap.set("n", "<leader>ha", function()
--      require("copilot-chat.panel").accept() -- inserts the currently selected suggestion
--    end, { desc = "Copilot Chat: Accept suggestion" })

    -- Chat about the *current file* without typing #file:/path every time
    vim.keymap.set("n", "<leader>ac", function()
      -- If we accidentally run this while focused in CopilotChat,
      -- fall back to the alternate buffer (#) which is usually your code file.
      local src_buf = vim.api.nvim_get_current_buf()
      if vim.bo[src_buf].filetype == "copilot-chat" then
        local alt = vim.fn.bufnr("#")
        if alt ~= -1 then src_buf = alt end
      end

      local abs = vim.api.nvim_buf_get_name(src_buf)
      if abs == "" then
        vim.notify("No file name for current buffer", vim.log.levels.WARN)
        return
      end

      local rel = vim.fn.fnamemodify(abs, ":.") -- nicer than /home/aidan/...
      require("CopilotChat").toggle()

      -- Wait for the chat window to exist, then type into it
      vim.schedule(function()
        -- CopilotChat buffer is usually focused after toggle; just feed keys
        vim.fn.feedkeys("#file:" .. rel .. "\n", "n")
        vim.cmd("startinsert!")
      end)
    end, { desc = "CopilotChat: context = current file" })
    vim.keymap.set("n", "<leader>hp", ":Copilot panel<CR>", { desc = "Copilot Panel" })
    vim.keymap.set("n", "<leader>ha", ":CopilotAction<CR>", { desc = "Copilot Action" })
    vim.keymap.set("i", "<C-l>", 'copilot#Accept("")', {
      expr = true,
      replace_keycodes = false,
      desc = "Copilot Accept",
    })

  end,
})

vim.keymap.set("n", "<leader>gB", function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values

  -- 1. Helper function to open file picker for a specific branch
  local function open_file_picker(branch)
    pickers.new({}, {
      prompt_title = "Files from " .. branch,
      finder = finders.new_oneshot_job({
        "git", "ls-tree", "-r", "--name-only", branch
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        local function open_selected()
          local entry = action_state.get_selected_entry()
          local file = entry and (entry.value or entry[1]) or action_state.get_current_line()

          if not file or file == "" then
            vim.notify("No file selected", vim.log.levels.WARN)
            return
          end

          actions.close(prompt_bufnr)

          vim.cmd("new")
          vim.bo.buftype = "nofile"
          vim.bo.bufhidden = "wipe"
          vim.bo.swapfile = false
          vim.bo.readonly = true

          -- Load file content from git
          local res = vim.system({ "git", "show", branch .. ":" .. file }, { text = true }):wait()
          if res.code ~= 0 then
            vim.notify(res.stderr or "git show failed", vim.log.levels.ERROR)
            return
          end

          vim.bo.modifiable = true
          vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(res.stdout or "", "\n", { plain = true }))
          vim.bo.modifiable = false
        end

        map("i", "<CR>", open_selected)
        map("n", "<CR>", open_selected)
        return true
      end,
    }):find()
  end

  -- 2. Open Branch Picker first
  require("telescope.builtin").git_branches({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- selection.value is the branch name
        if selection and selection.value then
          open_file_picker(selection.value)
        end
      end)
      return true
    end,
  })
end, { desc = "Browse files from another branch (Telescope)" })

-- Update default branch (main/master) from origin
vim.keymap.set("n", "<leader>gm", function()
  -- 1. Helper to find the default branch (prefer main, then master)
  local function get_default_branch()
    local res_main = vim.system({ "git", "rev-parse", "--verify", "main" }):wait()
    if res_main.code == 0 then return "main" end

    local res_master = vim.system({ "git", "rev-parse", "--verify", "master" }):wait()
    if res_master.code == 0 then return "master" end

    return nil -- Could not determine default branch locally
  end

  local default_branch = get_default_branch()
  if not default_branch then
    vim.notify("Could not detect 'main' or 'master' branch locally", vim.log.levels.ERROR)
    return
  end

  -- 2. Check current branch
  local current_branch = vim.trim(vim.fn.system("git rev-parse --abbrev-ref HEAD"))

  if current_branch == default_branch then
    -- We are ON the default branch -> Pull
    local res = vim.system({ "git", "pull", "origin", default_branch }):wait()
    if res.code == 0 then
      vim.notify("Pulled " .. default_branch .. " successfully", vim.log.levels.INFO)
    else
      vim.notify("Failed to pull " .. default_branch .. ": " .. (res.stderr or ""), vim.log.levels.ERROR)
    end
  else
    -- We are OFF the default branch -> Fetch update in background
    local res = vim.system({ "git", "fetch", "origin", default_branch .. ":" .. default_branch }):wait()
    if res.code == 0 then
      vim.notify(default_branch .. " updated successfully (background)", vim.log.levels.INFO)
    else
      vim.notify("Failed to update " .. default_branch .. ": " .. (res.stderr or ""), vim.log.levels.ERROR)
    end
  end
end, { desc = "Update default branch (main/master) from origin" })

-- Unified Git Branch Manager: Search or Create
vim.keymap.set("n", "<leader>gs", function()
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local builtin = require("telescope.builtin")

  builtin.git_branches({
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        local prompt = action_state.get_current_line()
        actions.close(prompt_bufnr)

        if selection then
          -- Default behavior: switch to selected branch
          -- Use Telescope's native checkout logic or manual?
          -- Manual is safer to ensure we use the 'switch' logic we want.
          local branch = selection.value
          -- If it's a remote branch, track it
          if branch:find("^origin/") then
             -- Strip origin/ to create local tracking branch
             local local_branch = branch:gsub("^origin/", "")
             local res = vim.system({ "git", "checkout", "-b", local_branch, "--track", branch }):wait()
             if res.code ~= 0 then
               -- Fallback just in case (e.g. branch exists)
               vim.system({ "git", "checkout", local_branch }):wait()
             end
          else
             vim.system({ "git", "checkout", branch }):wait()
          end
          vim.notify("Switched to " .. branch, vim.log.levels.INFO)
        elseif prompt ~= "" then
          -- No selection matched -> Ask to create new branch
          local confirmation = vim.fn.confirm("Branch '" .. prompt .. "' does not exist. Create?", "&Yes\n&No", 1)
          if confirmation == 1 then
            local res = vim.system({ "git", "checkout", "-b", prompt }):wait()
            if res.code == 0 then
              vim.cmd("redraw")
              vim.notify("Created and switched to " .. prompt, vim.log.levels.INFO)
            else
              vim.notify("Failed to create branch: " .. (res.stderr or ""), vim.log.levels.ERROR)
            end
          end
        end
      end)
      return true
    end,
  })
end, { desc = "Git: Switch branch or create new" })

