#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install Bash 4.
brew install bash
brew install bash-completion@2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install grep
brew install openssh
brew install curl
brew install cmake

brew install vim
brew install neovim

brew install ag
brew install git
brew install git-lfs
brew install gpg
brew install heroku
brew install irssi
brew install nvm
brew install rbenv
brew install redis
brew install ssh-copy-id
brew install tig
brew install tmux
brew install webkit2png
brew install yarn

# Install brew-cask
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew cask install 1password
brew cask install alfred
brew cask install dash
brew cask install discord
brew cask install dropbox
brew cask install firefox
brew cask install google-chrome
brew cask install google-chrome-canary
brew cask install imageoptim
brew cask install iterm2
brew cask install karabiner-elements
brew cask install keybase
brew cask install nordvpn
brew cask install omnifocus
brew cask install rescuetime
brew cask install slack
brew cask install spectacle
brew cask install spotify
brew cask install trailer
brew cask install transmission
brew cask install vlc
brew cask install virtualbox
brew cask install visual-studio-code

# Remove outdated versions from the cellar.
brew cleanup
