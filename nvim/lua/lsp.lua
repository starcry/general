-- LSP Configuration
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")

require("lspconfig").yamlls.setup({
  settings = {
    yaml = {
      schemas = {
        kubernetes = "/*.yaml",  -- Auto-detect Kubernetes YAML files
      },
      validate = true,  -- Enable real-time validation
      completion = true, -- Enable auto-completion
      hover = true, -- Show hover info for YAML properties
    },
  },
})


lspconfig.terraformls.setup({
  cmd = { "terraform-ls", "serve" },
  filetypes = { "terraform", "terraform-vars", "tf", "hcl" },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  autostart = true,
  init_options = {
    experimentalFeatures = {
      validation = true,
      validateOnSave = true,
      fullValidation = true  -- 🚀 Try forcing Terraform LSP to return all errors
    },
    diagnostics = {
      validateOnSave = true,
      fullValidation = true  -- 🚀 Extra attempt to ensure full diagnostics
    }
  }
--  on_attach = function(client, bufnr)
--    client.server_capabilities.documentFormattingProvider = false  -- Disable autoformat
--  end,
})

lspconfig.bashls.setup({
  cmd = { "bash-language-server", "start" },
  filetypes = { "sh", "bash", "zsh" },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  autostart = true,
})

lspconfig.ansiblels.setup({
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml", "yaml.ansible", "yml" }, -- Ensure it works with all YAML-based files
  root_dir = util.root_pattern("ansible.cfg", ".ansible-lint") or vim.fn.getcwd(),
  settings = {
    ansible = {
      python = {
        interpreterPath = "python", -- Ensure it's using the correct Python binary
      },
      ansible = {
        path = "ansible",
      },
      executionEnvironment = {
        enabled = false, -- Set to true if you're using Ansible Execution Environments
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
          path = "ansible-lint", -- Make sure ansible-lint is installed
        },
      },
    },
  },
  single_file_support = true, -- Ensures LSP works in single files
})

lspconfig.dockerls.setup({
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_dir = lspconfig.util.root_pattern("Dockerfile"),
  single_file_support = true,
})

-- Setup Helm LS
lspconfig.helm_ls.setup {
  filetypes = { "helm" },
  settings = {
    ['helm-ls'] = {
      yamlls = {
        path = "yaml-language-server", -- Ensure yaml-language-server is used
      }
    }
  }
}

-- Setup YAML LS (if not already configured)
lspconfig.yamlls.setup({})
