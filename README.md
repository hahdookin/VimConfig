<!-- Template by: https://github.com/AOrps/readme -->
# VimConfig
Simple all-in-one setup for both Vim and Nvim

## :card_file_box: Directory Explanation
After running `setup.sh`, your `~` directory should look something like this:

```
~/
├─── .config/nvim/init.vim        :: Main entry for neovim, source .vim/init.vim and updates rtp and packpath
├─── .vimrc                       :: Main entry for vim, sources .vim/init.vim
└─── .vim/
     ├─── init.vim                :: Actual vimrc commands
     ├─── plugins.vim             :: Plugin configs
     ├─── vim9.vim                :: Vim9 commands (Vim9 only)
     ├─── nvim.lua                :: Lua commands (NVim only)
     ├─── vim/pack/bundle/
     │             ├─── start/    :: Vim ONLY Plugins enabled automatically
     │             └─── opt/      :: Vim ONLY Plugins to enable manually with :packadd
     ├─── nvim/pack/bundle/
     │              ├─── start/   :: NVim ONLY Plugins enabled automatically
     │              └─── opt/     :: NVim ONLY Plugins to enable manually with :packadd
     ├─── common/pack/bundle/
     │                ├─── start/ :: Plugins enabled automatically
     │                └─── opt/   :: Plugins to enable manually with :packadd
     └─── temp/
          └─── undo/              :: Directory for undo files

```

## Overrides
If you want to have any overrides applied, create a `overrides.vim` file in the `~/.vim/` directory. These commands will be ran last.
