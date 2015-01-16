#!/bin/sh
if ! [ -f "/usr/local/bin/brew" ]; then
	echo "Installing homebrew..."
	
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew doctor
fi

if ! [ -f "/usr/local/bin/pip" ]; then
	echo "Installing pip..."
	
	sudo easy_install pip
fi

if ! [ -f "/usr/local/bin/cider" ]; then
	echo "Installing cider..."
	
	sudo pip install cider
fi

if ! [ -f "~/dotfiles" ]; then
	cd ~
	git clone https://github.com/humboldtjs/dotfiles.git
fi

if ! [ -f "~/.cider" ]; then
	ln -s "~/dotfiles/.cider" "~/.cider"
fi