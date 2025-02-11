-- LSP Configuration
local lspconfig = require("lspconfig")

lspconfig.terraformls.setup({
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  autostart = true,
	settings = {
    terraformls = {
      experimentalFeatures = { validation = true },  -- Enable deeper validation
      diagnostics = { validateOnSave = true },  -- Ensure all diagnostics appear
    }
  }
--  on_attach = function(client, bufnr)
--    client.server_capabilities.documentFormattingProvider = false  -- Disable autoformat
--  end,
})
