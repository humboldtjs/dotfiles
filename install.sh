#!/bin/sh

cleanupInstall()
{
	if [ -d /opt/homebrew-cask/Caskroom/$1/latest ]; then
		echo " $1... CLEANUP"
		brew cask remove $1
	fi
}

testInstall()
{
	if ! [ -d "/Applications/${1}" ]; then
		echo " $2... INSTALL"
		brew cask install $2
		if ! [ "$3" == "noremove" ]; then
			LATEST="$3"
			if [ -z "$3" ]; then
				LATEST="latest"
			fi
			sudo cp -R /opt/homebrew-cask/Caskroom/$2/${LATEST}/*.app /Applications/
			brew cask remove $2
		fi
	else
		echo " $1... OK"
	fi
}


### MAKE SURE OUR PRE-REQUISITES ARE INSTALLED
echo "PREREQUISITES"
if ! [ -f "/usr/local/bin/brew" ]; then
	echo " homebrew... INSTALL"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew doctor
else
	echo " homebrew... OK"
fi

#if ! [ -f "/usr/local/bin/brew-cask" ]; then
#	echo " brew-cask... INSTALL"
#	brew install caskroom/cask/brew-cask
#else
#	echo " brew-cask... OK"
#fi

if ! [ -f "/usr/local/bin/pip" ]; then
	echo " pip... INSTALL"
	brew install python3
	sudo easy_install pip
else
	echo " pip... OK"
fi

if ! [ -f "/usr/local/bin/cider" ]; then
	echo " cider... INSTALL"
	sudo pip3 install cider
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

echo "UPDATING CASKROOM"
brew tap homebrew/cask

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

cleanupInstall adobe-creative-cloud
testInstall Adobe\ Creative\ Cloud adobe-creative-cloud noremove
if ! [ -d "/Applications/Adobe Creative Cloud" ]; then
	open /opt/homebrew-cask/Caskroom/adobe-creative-cloud/latest/Creative\ Cloud\ Installer.app
fi

FFMPEG=`ffmpeg 2>&1 | grep -i vpx`
if [ -z "$FFMPEG" ]; then
	brew reinstall ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-frei0r --with-libass --with-libvo-aacenc --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-opus --with-rtmpdump --with-speex --with-theora --with-tools
fi

sudo npm install -g typescript
sudo npm install -g imageoptim-cli

if ! [ -d "extracommands/platform-tools" ]; then
	cd extracommands
	wget "https://dl.google.com/android/repository/platform-tools-latest-darwin.zip" -O adb.zip
	unzip adb.zip
	rm adb.zip
	cd ..
fi

echo "MAC APP STORE INSTALLS"
mas install 880001334  # Reeder 3
mas install 1091189122 # Bear
mas install 731829889  # Mindmaple Pro
mas install 897118787  # Shazam
mas install 411643860  # DaisyDisk
mas install 919269455  # Stuffit Expander
#mas install 497799835  # Xcode

echo "CLEANUP DOCK"
dockutil --remove "Contacts" --no-restart
dockutil --remove "Notes" --no-restart
dockutil --remove "Launchpad" --no-restart
dockutil --remove "Reminders" --no-restart
dockutil --remove "Maps" --no-restart
dockutil --remove "Photos" --no-restart
dockutil --remove "Messages" --no-restart
dockutil --remove "Facetime" --no-restart
dockutil --remove "iBooks" --no-restart
dockutil --remove "App Store" --no-restart
dockutil --remove "System Preferences" --no-restart
dockutil --add "/Applications/Reeder.app" --after "Calendar" --no-restart

echo ""
echo "If this was the first time, you ran this, make sure to restart the dock."
echo "Use the following command:"
echo ""
echo "> killall Dock"
echo ""
