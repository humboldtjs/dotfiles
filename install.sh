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

brew cask install textmate # no longer need to do testInstall because cask installs textmate in the correct place already
testInstall Dropbox.app dropbox
testInstall ownCloud.app owncloud noremove
testInstall Skype.app skype
cleanupInstall adobe-creative-cloud
testInstall Adobe\ Creative\ Cloud adobe-creative-cloud noremove
if ! [ -d "/Applications/Adobe Creative Cloud" ]; then
	open /opt/homebrew-cask/Caskroom/adobe-creative-cloud/latest/Creative\ Cloud\ Installer.app
fi
testInstall Xamarin\ Studio.app xamarin-studio 5.10.0.871-0
testInstall VLC.app vlc 2.2.1
testInstall Spotify.app spotify
testInstall SourceTree.app sourcetree 2.0.5.7
testInstall Cyberduck.app cyberduck 4.7.3
testInstall Miro\ Video\ Converter.app miro-video-converter
testInstall Firefox.app firefox 42.0

FFMPEG=`ffmpeg 2>&1 | grep -i vpx`
if [ -z "$FFMPEG" ]; then
	brew reinstall ffmpeg --with-fdk-aac --with-ffplay --with-freetype --with-frei0r --with-libass --with-libvo-aacenc --with-libvorbis --with-libvpx --with-opencore-amr --with-openjpeg --with-opus --with-rtmpdump --with-speex --with-theora --with-tools
fi
