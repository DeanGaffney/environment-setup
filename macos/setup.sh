#!/bin/bash

# Check if Homebrew is installed
if ! which -s brew; then
  # Install Homebrew
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  brew update
fi

if ! which -s ansible; then
  brew install ansible
fi

ansible-playbook -i inventory playbook.yml
