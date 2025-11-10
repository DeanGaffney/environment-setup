#!/bin/bash
set -e

echo "🚀 Setting up macOS development environment..."

# Check if Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
  echo "Installing Command Line Tools..."
  xcode-select --install
  echo "Please complete the Command Line Tools installation in the popup window."
  echo "   Press any key once installation is complete..."
  read -n 1 -s
else
  echo "Command Line Tools already installed"
fi

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
  echo "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # Add Homebrew to PATH for Apple Silicon or Intel
  if [[ $(uname -m) == 'arm64' ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  
  # Skip initial update to avoid git auth issues
  export HOMEBREW_NO_AUTO_UPDATE=1
  chmod -R go-w "$(brew --prefix)/share/zsh" 2>/dev/null || true
else
  echo "Homebrew already installed"
  # Skip auto-update during playbook run to avoid git auth issues
  export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Install Ansible
if ! command -v ansible &> /dev/null; then
  echo "📦 Installing Ansible..."
  brew install ansible
else
  echo "Ansible already installed"
fi

# Run the playbook
echo "Running Ansible playbook..."
ansible-playbook -i inventory playbook.yml

echo "Setup complete!"
