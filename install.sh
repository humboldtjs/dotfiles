#!/bin/sh

### MAKE SURE OUR PRE-REQUISITES ARE INSTALLED
echo "PREREQUISITES"
if ! [ -f "/usr/local/bin/brew" ]; then
	echo " homebrew... INSTALL"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew doctor
else
	echo " homebrew... OK"
fi

if ! [ -f "/usr/local/bin/brew-cask" ]; then
	echo " brew-cask... INSTALL"
	brew install caskroom/cask/brew-cask
else
	echo " brew-cask... OK"
fi

if ! [ -f "/usr/local/bin/pip" ]; then
	echo " pip... INSTALL"
	sudo easy_install pip
else
	echo " pip... OK"
fi

if ! [ -f "/usr/local/bin/cider" ]; then
	echo " cider... INSTALL"
	sudo pip install cider
else
	echo " cider... OK"
fi

echo "UPDATE DOTFILES"
if ! [ -d ~/dotfiles ]; then
	cd ~
	git clone https://github.com/humboldtjs/dotfiles.git
else
	cd ~/dotfiles
	git pull
fi

linkDotFile()
{
	if ! [ -d ~/.$1 ]; then
		if ! [ -f ~/.$1 ]; then
			echo [ -f "~/.$1" ];
			echo "~/.$1"
			echo " $1... LINK"
			ln -s ~/dotfiles/.$1 ~/.$1
		else
			echo " $1... OK"
		fi
	else
		echo " $1... OK"
	fi
}

linkDotFile "cider"
linkDotFile "config"
linkDotFile "gitconfig"
linkDotFile "gitignore"
linkDotFile "nanorc"

echo "CIDER RESTORE"
cider restore

echo "SETTINGS"
if ! [ "$SHELL" = "/usr/local/bin/fish" ]; then
	echo " fishshell... CHSH"

	if [ "`grep fish /etc/shells`" = "" ]; then
		echo /usr/local/bin/fish | sudo tee -a /etc/shells
	fi

	chsh -s /usr/local/bin/fish
else
	echo " fishshell... OK"
fi

echo " terminal... OK"
osascript -e "tell application \"Terminal\" to set current settings of front window to settings set \"Pro\""
osascript -e "tell application \"Terminal\" to set default settings to settings set \"Pro\""
osascript -e "tell application \"Terminal\" to set startup settings to settings set \"Pro\""

echo "INSTALL ADDITIONAL APPS"

if ! [ -d "/Applications/TextMate.app" ]; then
	echo " textmate... INSTALL"
	cd ~/dotfiles
	wget "https://api.textmate.org/downloads/release" -O TextMate.tbz

	mkdir tmp
	tar -xjf TextMate.tbz -C tmp
	rm TextMate.tbz
	
	sudo mv tmp/TextMate.app /Applications/TextMate.app

	rm -Rf tmp;

	sudo cp /Applications/TextMate.app/Contents/Resources/mate /usr/local/bin/mate
else
	echo " textmate... OK"
fi
