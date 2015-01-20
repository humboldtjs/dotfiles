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

if ! [ -f ~/.gitconfig ]; then
	ln -s ~/dotfiles/.gitconfig ~/.gitconfig
fi

if ! [ -f ~/.gitignore ]; then
	ln -s ~/dotfiles/.gitignore ~/.gitignore
fi

if ! [ -f ~/.nanorc ]; then
	ln -s ~/dotfiles/.nanorc ~/.nanorc
fi

echo "Cider restore..."
cider restore

if ! [ "$SHELL" = "/usr/local/bin/fish" ]; then
	echo "Setting shell to fish..."

	if [ "`grep fish /etc/shells`" = "" ]; then
		echo /usr/local/bin/fish | sudo tee -a /etc/shells
	fi

	chsh -s /usr/local/bin/fish
fi

osascript -e "tell application \"Terminal\" to set current settings of front window to settings set \"Pro\""
osascript -e "tell application \"Terminal\" to set default settings to settings set \"Pro\""
osascript -e "tell application \"Terminal\" to set startup settings to settings set \"Pro\""

echo "Installing apps..."
if ! [ -d "/Applications/TextMate.app" ]; then
	cd ~/dotfiles
	wget "https://api.textmate.org/downloads/release" -O TextMate.tbz

	mkdir tmp
	tar -xjf TextMate.tbz -C tmp
	rm TextMate.tbz
	
	sudo mv tmp/TextMate.app /Applications/TextMate.app

	rm -Rf tmp;

	sudo cp /Applications/TextMate.app/Contents/Resources/mate /usr/local/bin/mate
fi
