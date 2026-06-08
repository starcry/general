require("nvim-treesitter").setup({
  ensure_installed = { "markdown", "markdown_inline", "c_sharp", "yaml", "dockerfile", "bash", "json", "go" },
  highlight = { enable = true },
  indent = { enable = true },
})
