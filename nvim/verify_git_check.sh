#!/bin/bash
# This script verifies that the git check correctly identifies when the current branch is behind the remote.
set -e

# Setup test directories
TEST_DIR=$(mktemp -d)
echo "Test Dir: $TEST_DIR"
cd "$TEST_DIR"

# Create Repos (Same setup)
mkdir repo_a
cd repo_a
git init --bare
cd ..

git clone repo_a repo_b
cd repo_b
git config user.email "you@example.com"
git config user.name "Your Name"
git checkout -b master || git checkout master
touch README.md
git add README.md
git commit -m "Initial commit"
git push origin master
cd ..

git clone repo_a repo_c
cd repo_c
git config user.email "you@example.com"
git config user.name "Your Name"
git checkout master
touch feature.txt
git add feature.txt
git commit -m "New feature"
git push origin master
cd ..

# Now Repo A has 2 commits. Repo B has 1. Repo B is behind by 1.
# IMPORTANT: In Repo B, checkout a different feature branch
cd repo_b
git checkout -b my-feature
cd ..

# Create minimal init.lua
cat <<EOF > test_init.lua
vim.opt.rtp:prepend("/home/aidan/git/general/nvim")
vim.notify = function(msg, level)
  io.stderr:write("NOTIFY: " .. msg .. "\n")
end

require("git")

-- Quit after 5 seconds to give time for async fetch
vim.defer_fn(function()
  vim.cmd("qa!")
end, 5000)
EOF

# Run Neovim in Repo B (which is on 'my-feature', but 'master' is behind)
cd repo_b
echo "Running Neovim..."
nvim --headless --clean -u ../test_init.lua > output.txt 2>&1

echo "Checking output..."
cat output.txt
if grep -q "NOTIFY: Git: Your branch 'master' is behind origin by 1 commit(s)" output.txt; then
  echo "SUCCESS: Notification found."
else
  echo "FAILURE: Notification not found."
  exit 1
fi
