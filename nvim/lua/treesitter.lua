require("nvim-treesitter.configs").setup({
	ensure_installed = { "c_sharp", "yaml", "dockerfile", "bash", "json", "go" },
  highlight = { enable = true },
	indent = { enable = true },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  }
})
