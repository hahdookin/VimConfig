#!/usr/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Delete previously installed vimrc
sed_cmd='/" hahdookin\/VimConfig START/,/" hahdookin\/VimConfig END/d'
if [[ "$OSTYPE" == "darwin"* ]]; then
    # osx type
    sed -i '' "$sed_cmd" ~/.vimrc
else
    sed -i "$sed_cmd" ~/.vimrc
fi

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

for plugin in $(cat plugins_list.txt); do
    if [ -d $HOME/.vim/common/pack/bundle/start/${plugin#*/} ]; then
        # Plugins already installed, try to pull
        output=$(git \
            --git-dir=$HOME/.vim/common/pack/bundle/start/${plugin#*/}/.git \
            --work-tree=$HOME/.vim/common/pack/bundle/start/${plugin#*/}/ pull 2>&1)
        COLOR="$( (( $? != 0)) && echo $RED || echo $GREEN)"
        printf "$COLOR"$plugin": $NC""$output\n"
    else
        # Install plugin
        printf "$BLUE"$plugin": $NC"
        git clone https://github.com/$plugin ~/.vim/common/pack/bundle/start/${plugin#*/}
    fi
done
