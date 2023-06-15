#!/bin/bash

# Check if Homebrew is installed
if ! which -s brew; then
  # Install Homebrew
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(homebrew/bin/brew shellenv)"
  brew update --force --quiet
  chmod -R go-w "$(brew --prefix)/share/zsh"
else
  brew update
fi

if ! which -s ansible; then
  brew install ansible
fi

ansible-playbook -i inventory playbook.yml
