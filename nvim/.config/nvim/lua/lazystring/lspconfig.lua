local lspconfig = require('lspconfig')
local servers = {
  'gopls',
}

for _, server in ipairs(servers) do
  lspconfig[server].setup{}
end
