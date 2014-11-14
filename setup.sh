#!/bin/bash

PLUGINS=( \
	"bling/vim-airline" \ 
	"paranoida/vim-airlineish" \ 
	"kien/ctrlp.vim" \ 
	"tpope/vim-fugitive" \ 
	"mhinz/vim-startify" \ 
	"Shougo/neocomplcache.vim" \ 
	"scrooloose/syntastic" \ 
	"airblade/vim-gitgutter" \ 
	"Lokaltog/vim-easymotion" \ 
)

# Check not overwriting an existing vimrc

if [ -e ~/.vimrc ] 
then

	read -p "~/.vimrc already exists, replace it? (y/n) " -n 1 -r
	echo

	if [[ ! $REPLY =~ ^[Yy]$ ]] 
	then
		echo "Rename ~/.vimrc and try again"
		exit
	fi
fi

# Ask which bashrc to symlink

read -p "Enter bashrc filename for this system (.bashrc, .profile, .bash_profile, etc): " -r

BASHRC=$REPLY

# Check not overwriting the bashrc

if [ -e $BASHRC ] 
then

	read -p "$BASHRC already exists, replace it? (y/n) " -n 1 -r
	echo

	if [[ ! $REPLY =~ ^[Yy]$ ]] 
	then
		echo "Rename $BASHRC and try again"
		exit
	fi
fi

CONFIGPATH=$(cd .; pwd)

# Link vimrc & profile

ln -s $CONFIGPATH/vimrc ~/.vimrc

# ln -s $CONFIGPATH/profile ~/$BASHRC

pushd .

# Setup vim plugins

mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/colors
mkdir -p ~/.vim/bundle

cd ~/.vim/autoload

wget https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ../colors

wget https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim

cd ../bundle

for PLUGIN in "${PLUGINS[@]}"
do
	EXTENSION=".git"
	git clone "https://github.com/$PLUGIN$EXTENSION"
done

# Only install taglist if ctags is installed

if type "ctags" > /dev/null
then
	git clone https://github.com/vim-scripts/taglist.vim
else
	echo "ctags not installed, skipping taglist.vim"
fi

popd

echo "All done"

