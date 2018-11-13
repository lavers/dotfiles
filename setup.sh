#!/bin/bash

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

CONFIG_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)

for FILE in vimrc zshrc gitconfig screenrc
do

	ln -s $CONFIG_DIR/$FILE ~/.$FILE

done
