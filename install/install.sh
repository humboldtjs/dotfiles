#!/bin/sh

function brewinstall {

	if [ "`brew list | grep $1`" = "" ]; then
		brew install $1
	fi

}

function caskinstall {
	if [ "`brew cask list | grep $1`" = "" ]; then
		brew cask install $1
	fi
}

function brewtap {
	if ! [ -d /usr/local/Library/Taps/$1 ]; then
		brew tap $2
	fi	
}

echo "Installing ZSH"
echo "--------------"
# Check if default shell is zsh
if [ "$SHELL" = "/bin/zsh" ]; then
	# zsh is the default shell
	echo "ZSH is already the current shell"
else
	# we should set the shell to zsh
	echo "Changing shell to ZSH"
	chsh -s /bin/zsh
fi
echo ""

echo "Installing Homebrew"
echo "-------------------"
if ! [ "`brew`" = "" ]; then
	# brew is already installed
	echo "Homebrew is already installed"
else
	# brew is not installed
	ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
fi
echo ""

echo "Adding additional taps to Homebrew"
echo "----------------------------------"
brewtap josegonzalez-php josegonzalez/php
brewtap homebrew-dupes homebrew/dupes
brewtap phinze-cask phinze/homebrew-cask
brew update
echo ""

echo "Installing commandline software"
echo "-------------------------------"
brewinstall git
brewinstall brew-cask
brewinstall zlib
brewinstall xvid
brewinstall x264
brewinstall theora
brewinstall faac
brewinstall jpeg
brewinstall lame
brewinstall libogg
brewinstall libpng
brewinstall libvo-aacenc
brewinstall libvorbis
brewinstall libvpx
brewinstall ffmpeg
brewinstall p7zip
brewinstall readline
brewinstall rename
brewinstall sqlite
echo ""

echo "Setting up dotfiles"
echo "-------------------"
cd ~
if [ -d dotfiles ]; then
	cd dotfiles
	git pull
	cd ~
else
	git clone https://github.com/humboldtjs/dotfiles.git
fi
ln -s ~/dotfiles/casks /usr/local/Library/Taps/my-casks > null &2> null
echo ""

echo "Installing desktop software"
echo "---------------------------"
caskinstall adium
caskinstall adobe-air
caskinstall pixen
caskinstall cyberduck
caskinstall dropbox
caskinstall firefox
caskinstall fluid
caskinstall google-chrome
caskinstall miro-video-converter
caskinstall namemangler
caskinstall shortcat
caskinstall skype
caskinstall sourcetree
caskinstall spotify
caskinstall textmate2
caskinstall transmission
caskinstall vlc
export HOMEBREW_CASK_OPTS="--appdir=/Applications"
brew cask linkapps > null &2> null
echo ""

echo "Installing MAMP"
echo "---------------"
if [ -d /Applications/MAMP ]; then
	echo "MAMP is already installed"
else
	cd /tmp
	curl -o MAMP_MAMP_PRO_1.9.6.1.dmg.zip http://downloads.mamp.info/MAMP-PRO/releases/1.9.6.1/MAMP_MAMP_PRO_1.9.6.1.dmg.zip
	unzip MAMP_MAMP_PRO_1.9.6.1.dmg.zip
	rm MAMP_MAMP_PRO_1.9.6.1.dmg.zip
	hdiutil mount MAMP_MAMP_PRO_1.9.6.1.dmg
	cp -R /Volumes/MAMP\ \&\ MAMP\ PRO/MAMP /Applications/
	hdiutil unmount /Volumes/MAMP\ \&\ MAMP\ PRO/
	rm MAMP_MAMP_PRO_1.9.6.1.dmg

	rm /Applications/MAMP/conf/apache/httpd.conf
	ln -s ~/dotfiles/config/httpd.conf /Applications/MAMP/conf/apache/httpd.conf

	mkdir -p ~/Hosts
fi
echo ""

echo "Opening background apps"
echo "-----------------------"
open /Applications/Dropbox.app
echo ""

