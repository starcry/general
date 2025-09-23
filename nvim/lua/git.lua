vim.api.nvim_create_user_command("Gco", function(opts)
  local input = opts.fargs
  local func = input[1]
  local comment = table.concat(vim.list_slice(input, 2), " ")

  -- get current git branch
  local handle = io.popen("git rev-parse --abbrev-ref HEAD")
  local branch = handle:read("*a"):gsub("%s+", "")
  handle:close()

  local msg = string.format('%s: %s: %s', func, branch, comment)
  vim.fn.system({ "git", "commit", "-m", msg })
  print("Committed with message: " .. msg)
end, {
  nargs = "+",
  complete = nil,
  desc = "Commit with custom message template",
})
