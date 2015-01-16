#!/bin/sh
if ! [ -f "/usr/local/bin/brew" ]; then
	echo "-------------------"
	echo "Installing homebrew"
	echo "-------------------"
	
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi