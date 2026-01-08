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

local function run(cmd, cwd, cb)
  -- Neovim 0.10+
  if vim.system then
    vim.system(cmd, { cwd = cwd, text = true }, function(res)
      cb(res.code, res.stdout or "", res.stderr or "")
    end)
    return
  end

  -- Fallback for older Neovim: jobstart
  local out, err = {}, {}
  vim.fn.jobstart(cmd, {
    cwd = cwd,
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data) if data then out = data end end,
    on_stderr = function(_, data) if data then err = data end end,
    on_exit = function(_, code)
      cb(code, table.concat(out, "\n"), table.concat(err, "\n"))
    end,
  })
end

local function git_root()
  -- Fast, no shell; works in nvim 0.9+
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local start = (file ~= "" and vim.fs.dirname(file)) or vim.loop.cwd()
  local root = vim.fs.find(".git", { upward = true, path = start })[1]
  return root and vim.fs.dirname(root) or nil
end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function check_default_branch_behind_origin()
  local root = git_root()
  if not root then return end

  -- 1) Figure out default branch from origin/HEAD if available
  run({ "git", "symbolic-ref", "-q", "--short", "refs/remotes/origin/HEAD" }, root, function(code, stdout, _)
    local remote_head = (code == 0) and trim(stdout) or ""
    local branch = remote_head:match("^origin/(.+)$")

    -- Fallback: prefer main, then master (local existence check)
    local function fallback_branch(cb)
      run({ "git", "show-ref", "--verify", "--quiet", "refs/heads/main" }, root, function(c1)
        if c1 == 0 then return cb("main") end
        run({ "git", "show-ref", "--verify", "--quiet", "refs/heads/master" }, root, function(c2)
          if c2 == 0 then return cb("master") end
          cb(nil)
        end)
      end)
    end

    local function with_branch(b)
      if not b then return end

      -- 2) Fetch only that branch (quiet + no tags)
      run({ "git", "fetch", "--quiet", "--no-tags", "origin", b }, root, function(fetch_code, _, _)
        if fetch_code ~= 0 then return end

        -- 3) Count how many commits local is behind origin/<branch>
        run({ "git", "rev-list", "--count", (b .. "..origin/" .. b) }, root, function(rc, out, _)
          if rc ~= 0 then return end
          local behind = tonumber(trim(out)) or 0
          if behind > 0 then
            vim.schedule(function()
              vim.notify(
                ("Git: '%s' is behind origin/%s by %d commit(s)."):format(b, b, behind),
                vim.log.levels.WARN
              )
            end)
          end
        end)
      end)
    end

    if branch then
      with_branch(branch)
    else
      fallback_branch(with_branch)
    end
  end)
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Don’t steal startup time; run shortly after UI is up
    vim.defer_fn(check_default_branch_behind_origin, 700)
  end,
  desc = "Notify if default branch is behind origin on startup",
})
