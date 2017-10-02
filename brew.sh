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

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget --with-iri

# Install GnuPG to enable PGP-signing commits.
brew install gnupg

# Install more recent versions of some macOS tools.
brew install vim --with-override-system-vi
brew install grep
brew install openssh
brew install screen
brew install php
brew install gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
brew install aircrack-ng
brew install bfg
brew install binutils
brew install binwalk
brew install cifer
brew install dex2jar
brew install dns2tcp
brew install fcrackzip
brew install foremost
brew install hashpump
brew install hydra
brew install john
brew install knock
brew install netpbm
brew install nmap
brew install pngcheck
brew install socat
brew install sqlmap
brew install tcpflow
brew install tcpreplay
brew install tcptrace
brew install ucspi-tcp # `tcpserver` etc.
brew install xpdf
brew install xz

# Install other useful binaries.
brew install ack
#brew install exiv2
brew install ffmpeg
brew install git
brew install git-lfs
brew install gpg
brew install heroku
brew install hub
brew install imagemagick --with-webp
brew install irssi
brew install lua
brew install lynx
brew install node
brew install p7zip
brew install pigz
brew install pv
brew install rbenv
brew install redis
brew install rename
brew install rlwrap
brew install ruby-build
brew install speedtest_cli
brew install ssh-copy-id
brew install testssl
brew install tig
brew install tree
brew install vbindiff
brew install webkit2png
brew install yarn
brew install zopfli

# Install brew-cask
brew install caskroom/cask/brew-cask
brew tap caskroom/versions

brew cask install 1password 2> /dev/null
brew cask install alfred 2> /dev/null
brew cask install atom 2> /dev/null
brew cask install dash 2> /dev/null
brew cask install dropbox 2> /dev/null
brew cask install firefox 2> /dev/null
brew cask install flux 2> /dev/null
brew cask install google-chrome 2> /dev/null
brew cask install google-chrome-canary 2> /dev/null
brew cask install imageoptim 2> /dev/null
brew cask install iterm2 2> /dev/null
brew cask install karabiner-elements 2> /dev/null
brew cask install keybase 2> /dev/null
brew cask install postgres 2> /dev/null
brew cask install qlmarkdown 2> /dev/null
brew cask install quicklook-json 2> /dev/null
brew cask install rescuetime 2> /dev/null
brew cask install sketch 2> /dev/null
brew cask install slack 2> /dev/null
brew cask install spectacle 2> /dev/null
brew cask install spotify 2> /dev/null
brew cask install trailer 2> /dev/null
brew cask install transmission 2> /dev/null
brew cask install vlc 2> /dev/null
brew cask install virtualbox 2> /dev/null

brew cask alfred link

# Remove outdated versions from the cellar.
brew cleanup
brew cask cleanup
