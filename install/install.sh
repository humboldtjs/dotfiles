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

echo "Checking pre-requisites"
echo "-----------------------"
if [ "`make 2>&1 >/dev/null | grep 'not found'`" == "" ]; then
	# Xcode command line tools are note installed
	echo "Please install the Xcode Commandline Tools first"
	# quit here?
fi
echo ""

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
ln -s ~/dotfiles/settings/.nanorc ~/.nanorc > null &2> null

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
if ! [ -f /usr/local/Library/Taps/phinze-cask/lib/cask/actions.rb.orig ]; then
	cp /usr/local/Library/Taps/phinze-cask/lib/cask/actions.rb /usr/local/Library/Taps/phinze-cask/lib/cask/actions.rb.orig
fi
cp ~/dotfiles/install/actions.rb /usr/local/Library/Taps/phinze-cask/lib/cask/actions.rb
cp ~/dotfiles/install/actions.rb /usr/local/Library/LinkedKegs/brew-cask/rubylib/cask/actions.rb
brew cask linkapps > null 2> null
rm -Rf /Applications/app_mode_loader.app
rm -Rf /Applications/crash_report_sender.app
rm -Rf /Applications/crashreporter.app
rm -Rf /Applications/Delete\ VLC\ Preferences.app
rm -Rf /Applications/finish_installation.app
rm -Rf /Applications/FluidApp.app
rm -Rf /Applications/Google\ Chrome\ Helper.app
rm -Rf /Applications/Google\ Chrome\ Helper\ EH.app
rm -Rf /Applications/Google\ Chrome\ Helper\ NP.app
rm -Rf /Applications/plugin-container.app
rm -Rf /Applications/Prototype\ Droplet.app
rm -Rf /Applications/Relauncher.app
rm -Rf /Applications/updater.app
echo "Reindexing..."
mdimport /Applications
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

echo "Setting OSX defaults"
echo "--------------------"
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Enable subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2
# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Enable snap-to-grid for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true
# # Make Dock icons of hidden applications translucent
# defaults write com.apple.dock showhidden -bool true
# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# Disable the Ping sidebar in iTunes
defaults write com.apple.iTunes disablePingSidebar -bool true
# Disable all the other Ping stuff in iTunes
defaults write com.apple.iTunes disablePing -bool true
# Reset Launchpad
[ -e ~/Library/Application\ Support/Dock/*.db ] && rm ~/Library/Application\ Support/Dock/*.db
# Kill affected applications
for app in Finder Dock Mail Safari iTunes iCal Address\ Book SystemUIServer; do killall "$app" > /dev/null 2>&1; done
echo ""

echo "Opening background apps"
echo "-----------------------"
open /Applications/Dropbox.app
echo ""

