#!/bin/sh
if ! [ -f "/usr/local/bin/brew" ]; then
	echo "Installing homebrew..."
	
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! [ -f "/usr/local/bin/cider" ]; then
	echo "Installing cider..."
	
	pip install -U cider
fi

if ! [ -f "/usr/local/bin/git" ]; then
	echo "Installing git..."
	
	brew install git
fi

if ! [ -f "~/dotfiles" ]; then
	cd ~
	git clone https://github.com/humboldtjs/dotfiles.git
fi

if ! [ -f "~/.cider" ]; then
	ln -s "~/dotfiles/.cider" "~/.cider"
fi