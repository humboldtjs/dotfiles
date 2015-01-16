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

if ! [ -d ~/dotfiles ]; then
	cd ~
	
	git clone https://github.com/humboldtjs/dotfiles.git
else
	cd ~/dotfiles
	
	git pull
fi

if ! [ -d ~/.cider ]; then
	ln -s ~/dotfiles/.cider ~/.cider
fi

if ! [ -d ~/.config ]; then
	ln -s ~/dotfiles/.config ~/.config
fi

echo "Cider restore..."
cider restore

if ! [ "$SHELL" = "/usr/local/bin/fish" ]; then
	echo "Setting shell to fish..."
	chsh -s /usr/local/bin/fish
fi
