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
