# completion-vcard

vCard completion source for native Neovim LSP autocompletion (see `:h lsp-autocompletion`), [nvim-cmp](https://github.com/hrsh7th/nvim-cmp), [nvim-compe](https://github.com/hrsh7th/nvim-compe), and [completion-nvim](https://github.com/nvim-lua/completion-nvim).

## Usage

### Native autocompletion

Add the following to `after/ftplugin/mail.lua`:


```lua
require('completion_vcard').setup_native('~/path/to/vcard/dir')
```

This will start an LSP client attached to a fake in-process LSP server that only support completion requests.

### nvim-cmp

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

### nvim-compe

```lua
require('completion_vcard').setup_compe('~/path/to/vcard/dir')

require('compe').setup({
    source = {
        vCard = true,
        -- probably some other sources as well
    }
})
```

### completion-nvim

```lua
require('completion_vcard').setup_completion('~/path/to/vcard/dir')

vim.g.completion_chain_complete_list = {
    { complete_items = { 'lsp', 'vCard' }},
    { mode = '<c-n>' }
}
```
