# completion-vcard

vCard completion source for [completion-nvim](https://github.com/nvim-lua/completion-nvim).

## Usage

```lua
require('completion_vcard').setup('~/path/to/vcard/dir')

vim.g.completion_chain_complete_list = {
    { complete_items = { 'lsp', 'vCard' }},
    { mode = '<c-n>' }
}
```
