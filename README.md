# gerrit.nvim

## Requirements

- Telescope plugin
- curl

## Setup

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

## Usage

`:Gerrit` command will open telescope list of your changes list

`<CR>` will checkout to last revision id of selected change on your local
