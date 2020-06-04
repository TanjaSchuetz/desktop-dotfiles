#!/usr/bin/env bash

##################
# main editors

# kate
yay -S --noconfirm kate

# geany
yay -S --noconfirm geany geany-plugins geany-themes editorconfig-geany

# vim/neovim
yay -S --noconfirm neovim vim-plugins

sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

pip install --user neovim

# emacs doom
yay -S --noconfirm emms emacs
git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d
~/.emacs.d/bin/doom install
