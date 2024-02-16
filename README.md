# btoggle.nvim
vim pluggin to toogle stuff

## What does it do?
The default behavoir let's you quickly toggle between boolean values:
* `false` -> `true`
* `False` -> `True`
* `true` -> `false`
* `True` -> `False`

This plugin will always toggle the nearest found toggalable string after the current cursor position on the current line.
If no match was found after the cursor potion, the nearest match before the cursor is toggled.

## Installation
Using [lazy.nvim](https://github.com/folke/lazy.nvim)
``` lua 
{ 'tobser/btoggle.nvim' }
```

## Usage

add your mapping
```lua
    vim.keymap.set('n', '<leader>b', require("btoggle").toggle)
```

move your cursor to a line which contains `true` and press mapped keyes to toggle `true` to `false`:

    some line with the word true in it
will become

    some line with the word false in it

## Customizing

If you, for some reason, do not like the default boolean replacements, it is possible to customize the replacement behavior.
To replace `foo` with `bar` and `bar` with `bor` and `bor` with `foo` it is possible to call setup with a custom replacement table:

```lua
    local bt =  require("btoggle");
    bt.setup({
        ["foo"] = "bar",
        ["bar"] = "bor",
        ["bor"] = "foo"
    })
    vim.keymap.set('n', '<leader>b', bt.toggle)
```

`<leader>b` will now cycle through `foo` &rarr; `bar` &rarr; `bor` &rarr; `foo` etc. 

## ToDo
 * It would be nice to have some better word matching behavior. The plugin would understand what vim does consider a word. So `falsehood` would currently become `truehood`... but on the other hand it's not that big of a deal and this todo may never be done.
