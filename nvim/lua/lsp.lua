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
lspconfig.yamlls.setup({
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml", "yml" },
  settings = {
    yaml = {
      schemas = {
        kubernetes = "*.yaml",
      },
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

-- [OPTION B] omnisharp
require("lspconfig").omnisharp.setup({
  -- If installed via package manager or Mason:
  -- cmd = { "omnisharp" },
	cmd = {
		-- Use the path from :Mason if needed (e.g. "~/.local/share/nvim/mason/bin/omnisharp")
		"omnisharp",
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
	},
  -- Or full path to the OmniSharp executable, e.g.:
  -- cmd = { "/path/to/omnisharp/OmniSharp", "--languageserver", "--hostPID", tostring(pid) },

  filetypes = { "cs" },
  root_dir = require("lspconfig.util").root_pattern("*.sln", "*.csproj", ".git"),

  -- Additional OmniSharp-specific settings
  enable_editorconfig_support = true,
  enable_roslyn_analyzers = true,
  enable_import_completion = true,
  -- ...
})

-- ✅ PowerShell LSP
lspconfig.powershell_es.setup({
  bundle_path = vim.fn.expand("$HOME/.local/share/nvim/mason/packages/powershell-editor-services"),
  shell = "pwsh",
  filetypes = { "ps1", "psm1" },
})

-- ✅ JSON LSP
lspconfig.jsonls.setup({
  cmd = { "vscode-json-language-server", "--stdio" },
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

lspconfig.gopls.setup({
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
        nilness = true,
        unusedwrite = true,
      },
      staticcheck = true,
    },
  },
})

-- New TypeScript LSP (replaces tsserver)
lspconfig.tsserver = nil -- Just in case it's been loaded

lspconfig.ts_ls.setup({
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = {
    "typescript", "typescriptreact", "typescript.tsx",
    "javascript", "javascriptreact", "javascript.jsx"
  },
  root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
  single_file_support = true,
  init_options = {
    hostInfo = "neovim",
  },
})

require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp", "bashls", "jsonls", "gopls", "ts_ls" },
  automatic_installation = { exclude = {} },
})
