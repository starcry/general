-- Load nvim-tree on startup
--require("nvim-tree").setup()
require("nvim-tree").setup({
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  filters = {
    dotfiles = false, -- Show dotfiles
    custom = {}, -- Disable custom filters
    exclude = {}, -- No exclusions
    git_ignored = false, -- Show files ignored by Git
  },
  sort = {
    sorter = function(nodes)
      table.sort(nodes, function(a, b)
        local function natural_key(name)
          -- Pad all numbers with leading zeros for comparison (e.g. "1" -> "000000000001")
          return name:gsub("%d+", function(n)
            return string.format("%012d", tonumber(n))
          end):lower()
        end

        if a.type == b.type then
          return natural_key(a.name) < natural_key(b.name)
        else
          return a.type == "directory"
        end
      end)
    end,
  },
})

-- Prevent plugins (like CopilotChat diff) from hijacking the NvimTree window
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.opt_local.winfixbuf = true
    vim.opt_local.winfixwidth = true -- optional: stops width wobble
  end,
})

-- Auto-open File Tree when starting Neovim
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})

-- Close NvimTree automatically when CopilotChat opens
vim.api.nvim_create_autocmd("FileType", {
  pattern = "copilot-chat",
  callback = function()
    local ok, api = pcall(require, "nvim-tree.api")
    if ok and api.tree.is_visible() then
      api.tree.close()
    end
  end,
})

