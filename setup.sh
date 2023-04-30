#!/usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Delete previously installed vimrc
sed '/" hahdookin\/VimConfig START/,/" hahdookin\/VimConfig END/d' -i ~/.vimrc

vimrc=(
    '" hahdookin/VimConfig START'
    '" Injected by https://github.com/hahdookin. Enjoy!'
    'source $HOME/.vim/init.vim'
    'source $HOME/.vim/plugins.vim'
    'eval has("vim9script") && execute("source $HOME/.vim/vim9.vim")'
    'eval has("nvim") && execute("lua require(\"$HOME/.vim/nvim.lua\")")'
    'eval filereadable(expand("$HOME/.vim/overrides.vim")) && execute("source $HOME/.vim/overrides.vim")'
    '" hahdookin/VimConfig END'
)

for ((i = 0; i < ${#vimrc[@]}; i++)); do
    echo -e ${vimrc[$i]} >> ~/.vimrc
done

# Create directories
mkdir -p ~/.vim/temp/undo
mkdir -p ~/.vim/{common,vim,nvim}/pack/bundle/{opt,start}

common=(
    jiangmiao/auto-pairs
    neoclide/coc.nvim
    itchyny/lightline.vim
    airblade/vim-gitgutter
    hahdookin/minifuzzy.vim
    hahdookin/miniterm.vim
    pineapplegiant/spaceduck
    ap/vim-buftabline
    tpope/vim-commentary
    tpope/vim-fugitive
    frazrepo/vim-rainbow
    vimwiki/vimwiki
)


for plugin in ${common[@]}; do
    if [ -d $HOME/.vim/common/pack/bundle/start/${plugin#*/} ]; then
        git \
            --git-dir=$HOME/.vim/common/pack/bundle/start/${plugin#*/}/.git \
            --work-tree=$HOME/.vim/common/pack/bundle/start/${plugin#*/}/ pull
    else
        git clone https://github.com/$plugin ~/.vim/common/pack/bundle/start/${plugin#*/}
    fi
done
exit 1

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
