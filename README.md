# completion-vcard

vCard completion source for [completion-nvim](https://github.com/nvim-lua/completion-nvim), [nvim-compe](https://github.com/hrsh7th/nvim-compe), and [nvim-cmp](https://github.com/hrsh7th/nvim-cmp).

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
require('completion_vcard').setup_compe('~/path/to/vcard/dir')

require('compe').setup({
    source = {
        vCard = true,
        -- probably some other sources as well
    }
})
```

For `nvim-cmp`:

```lua
require('cmp').setup({
    -- ...
    sources = {
        { name = 'vCard' },
        -- ...
    },
})

require('cmp').register_source('vCard', require('completion_vcard').setup_cmp('~/path/to/vcard/dir'))
```
