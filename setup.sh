#!/usr/bin/env sh

# check if homebrew pakcage manager is installed
if [ ! -f $(which brew) ]; then
    echo "Installing Homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# check if carthage dependency manager is installed
if [ ! -f $(brew --prefix)/bin/carthage ]; then
    echo "Installing Carthage..."
    $(brew --prefix)/bin/brew install carthage
else
    echo "Updating Homebrew..."
    $(brew --prefix)/bin/brew update

    installedCarthageVersion=`$(brew --prefix)/bin/carthage version`
    latestCarthageVersion=`$(brew --prefix)/bin/brew info carthage|grep "^carthage: "|sed 's/[^0-9.]*\([0-9.]*\).*/\1/'`

    if [ ! "$installedCarthageVersion" == "$latestCarthageVersion" ]; then
        echo "Upgrading Carthage from $installedCarthageVersion to version $latestCarthageVersion"
        $(brew --prefix)/bin/brew upgrade carthage
    fi
fi

# update dependencies
if [ $(uname -n|grep MAMSIT|wc -l) -gt 0 ]; then
    echo "Updating dependencies..."
    $(brew --prefix)/bin/carthage update --platform Mac
else
    echo "Compiling dependencies..."
    $(brew --prefix)/bin/carthage bootstrap --platform Mac
fi
