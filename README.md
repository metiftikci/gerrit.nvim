# gerrit.nvim

```lua
require('packer').startup(function()
  use 'metiftikci/gerrit.nvim'
end)

require('gerrit').setup {
  username = "username",
  credentials = "",
  host = "https://gerrit.example.com",
}
```