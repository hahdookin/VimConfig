#!/usr/bin/bash

vimrc=(
    '" Injected by https://github.com/hahdookin. Enjoy!'
    'source $HOME/.vim/init.vim'
    'source $HOME/.vim/plugins.vim'
    'if has("vim9script")'
    '\tsource $HOME/.vim/vim9.vim'
    'endif'
    'if has("nvim")'
    '\tlua require("$HOME/.vim/nvim.lua")'
    'endif'
)

for ((i = 0; i < ${#vimrc[@]}; i++)); do
    echo -e ${vimrc[$i]} >> ~/.vimrc
done
exit 1

# Create directories
mkdir -p ~/.vim/temp/undo
mkdir -p ~/.vim/{common,vim,nvim}/pack/bundle/{opt,start}

must_have_plugins=(
    jiangmiao/auto-pairs
    neoclide/coc.nvim
    itchyny/lightline.vim
    pineapplegiant/spaceduck
    ap/vim-buftabline
    tpope/vim-commentary
    frazrepo/vim-rainbow
    vimwiki/vimwiki
)

optional_plugins=(
    morhetz/gruvbox
    tomasiser/vim-code-dark
)

for plugin in ${must_have_plugins[@]}; do
    # git clone https://github.com/$plugin ~/.vim/common/pack/bundle/start/
    echo https://github.com/$plugin
done

# Necessary
auto-pairs      # Insert matching pairs
coc.nvim        # LSP
lightline.vim   # Statusline
minifuzzy.vim   # Fuzzy-finder
miniterm.vim    # Terminal manager
startscreen.vim # Startscreen
vim-buftabline  # Show bufs in tabline
vim-commentary  # Comment stuff
vim-fugitive    # Git integration

# Colorschemes
gruvbox
spaceduck
vim-code-dark-master
papercolor-theme

# Unnecessary
tamagotchi.vim
rainbow
vim-scriptease
ShaderHighlight
vimwiki

# Candidates for deletion
testvim9
calendar.vim
