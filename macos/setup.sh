#!/bin/bash
#
read -rp "Did you setup your Github SSH Keys? (yes/no) " yn

case $yn in
y | yes) echo "Ok, proceeding with setup" ;;
n | no)
  echo "Do that first and then re-run this script. Exiting... "
  exit 1
  ;;
*)
  echo invalid response
  exit 1
  ;;
esac

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
