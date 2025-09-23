-- Neovim 0.11+ LSP config (no require('lspconfig') framework)

-- Optional: globals you want applied to all servers
-- vim.lsp.config('*', {
--   capabilities = ...,
--   root_markers = { '.git' },
-- })

-- YAML
vim.lsp.config('yamlls', {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yml' },
  settings = {
    yaml = {
      schemas = { kubernetes = '*.yaml' },
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

-- Terraform
vim.lsp.config('terraformls', {
  cmd = { 'terraform-ls', 'serve' },
  filetypes = { 'terraform', 'terraform-vars', 'tf', 'hcl' },
  init_options = {
    experimentalFeatures = { validateOnSave = true },
  },
  autostart = true,
})

-- Bash
vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash', 'zsh' },
  autostart = true,
})

-- Ansible
vim.lsp.config('ansiblels', {
  cmd = { 'ansible-language-server', '--stdio' },
  filetypes = { 'yaml', 'yaml.ansible', 'yml' },
  -- Prefer root markers over the old util.root_pattern
  root_markers = { 'ansible.cfg', '.ansible-lint', '.git' },
  settings = {
    ansible = {
      python = { interpreterPath = 'python' },
      ansible = { path = 'ansible' },
      executionEnvironment = { enabled = false },
      validation = {
        enabled = true,
        lint = { enabled = true, path = 'ansible-lint' },
      },
    },
  },
  single_file_support = true,
})

-- Dockerfile
vim.lsp.config('dockerls', {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  single_file_support = true,
})

-- Helm
vim.lsp.config('helm_ls', {
  filetypes = { 'helm' },
  settings = {
    ['helm-ls'] = { yamlls = { path = 'yaml-language-server' } }
  },
})

-- OmniSharp (C#)
vim.lsp.config('omnisharp', {
  cmd = { 'omnisharp', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) },
  filetypes = { 'cs' },
  root_markers = { '*.sln', '*.csproj', '.git' },
  enable_editorconfig_support = true,
  enable_roslyn_analyzers = true,
  enable_import_completion = true,
})

-- PowerShell
vim.lsp.config('powershell_es', {
  bundle_path = vim.fn.expand('$HOME/.local/share/nvim/mason/packages/powershell-editor-services'),
  shell = 'pwsh',
  filetypes = { 'ps1', 'psm1' },
})

-- JSON (with SchemaStore)
vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Go
vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
  settings = {
    gopls = {
      analyses = { unusedparams = true, nilness = true, unusedwrite = true },
      staticcheck = true,
    },
  },
})

-- TypeScript/JavaScript (new ts_ls)
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'typescript', 'typescriptreact', 'typescript.tsx',
    'javascript', 'javascriptreact', 'javascript.jsx',
  },
  root_markers = { 'tsconfig.json', 'package.json', 'jsconfig.json', '.git' },
  single_file_support = true,
  init_options = { hostInfo = 'neovim' },
})

-- Enable everything
vim.lsp.enable({
  'yamlls','terraformls','bashls','ansiblels','dockerls','helm_ls',
  'omnisharp','powershell_es','jsonls','gopls','ts_ls'
})

-- Your existing on-save hook is fine on 0.11
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.tf', '*.tfvars' },
  callback = function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    for _, client in ipairs(clients) do
      if client.name == 'terraformls' then
        pcall(function() vim.lsp.buf.format({ async = true }) end)
        pcall(function()
          vim.lsp.buf.code_action({
            context = { only = { 'source.validate' } },
            apply = true,
          })
        end)
        break
      end
    end
  end,
})

