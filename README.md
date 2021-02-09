# completion-vcard

vCard completion source for [completion-nvim](https://github.com/nvim-lua/completion-nvim) and [nvim-compe](https://github.com/hrsh7th/nvim-compe).

## Usage

For `completion-nvim`:

```lua
require('completion_vcard').setup_completion('~/path/to/vcard/dir')

vim.g.completion_chain_complete_list = {
    { complete_items = { 'lsp', 'vCard' }},
    { mode = '<c-n>' }
}
```

For `nvim-compe`:

```lua
require('completion_vcard').setup_compe('~/documents/contacts')

require('compe').setup({
    source = {
        vCard = true,
        -- probably some other sources as well
    }
})
```
