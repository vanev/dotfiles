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
# Powers Telescope's find_files/live_grep (and respects .gitignore/.ignore)
brew install ripgrep

brew install gh
brew install git
brew install git-lfs
brew install irssi
brew install nvm
brew install rbenv
brew install redis
brew install ssh-copy-id
brew install tailscale
brew install tig
brew install yarn

brew install --cask 1password
brew install --cask discord
brew install --cask docker
brew install --cask dropbox
brew install --cask firefox
brew install --cask ghostpepper
brew install --cask ghostty
brew install --cask google-chrome
brew install --cask imageoptim
brew install --cask karabiner-elements
brew install --cask obsidian
brew install --cask raycast
brew install --cask rectangle
brew install --cask signal
brew install --cask spotify
brew install --cask the-unarchiver
brew install --cask visual-studio-code
brew install --cask vlc

# Remove outdated versions from the cellar.
brew cleanup
