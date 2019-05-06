#!/bin/bash

DOTFILES=$(cd $(dirname $0); pwd)
EMACSD=$DOTFILES/.emacs.d
ZSH=$DOTFILES/zsh
TMUX=$DOTFILES/tmux
GIT=$DOTFILES/git
MISC=$DOTFILES/misc

EMACS_VER_ENABLED=24.4

M="mkdir"
T="touch"
L="ln"

deploy() {
    if [ ! -e $2 ]; then
        case $1 in
            $M) mkdir $2 ;;
            $T) touch $2 ;;
            $L) ln -s $3 $2 ;;
        esac
    fi
}

# Submodules initialization
cd $DOTFILES
git submodule update --init --recursive
git submodule foreach git pull origin master

# Emacs
which emacs > /dev/null
if [ $? = 0 ];then
    EMACS_VER=$(emacs --version | awk 'NR == 1 {print $3}' | cut -f1,2 -d.)
    if [ $(echo "$EMACS_VER >= $EMACS_VER_ENABLED" | bc) = 1 ]; then
        deploy $L $HOME/.emacs.d $EMACSD
        deploy $T $EMACSD/.scratch-log
        deploy $T $EMACSD/.scratch-log-prev
        deploy $M $EMACSD/backup
        cd $EMACSD
        # No need to call cask init. Cask file already exists.
        ./.cask/bin/cask
    fi
fi

# zsh
deploy $L $HOME/.zshrc $ZSH/.zshrc

# Tmux
deploy $L $HOME/.tmux.conf $TMUX/.tmux.conf

# Git
deploy $L $HOME/.gitconfig $GIT/.gitconfig

# bin
deploy $M $HOME/bin
deploy $L $HOME/bin/loadaverage $TMUX/loadaverage.sh
deploy $L $HOME/bin/used_mem $TMUX/used_mem.sh
if [[ ${OSTYPE} =~ darwin* ]]; then
    deploy $L $HOME/bin/mem $MISC/mem.sh
fi

## Vi
deploy $L $HOME/.vimrc $DOTFILES/.vimrc
deploy $M $HOME/.vim_swp

## Misc.
deploy $L $HOME/.inputrc $MISC/.inputrc
deploy $L $HOME/.screenrc $MISC/.screenrc

exit 0
