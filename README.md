# environment-setup

A repository that sets up my working environment using ansible

## Prerequisites

Before running the setup script, you'll need:

1. **GitHub Personal Access Token** - Generate one at <https://github.com/settings/tokens>
   - You'll be prompted for this during setup
   - Needs `repo` and `admin:public_key` scopes

2. **Git credentials ready**:
   - Your full name
   - Personal email address
   - Work email address (if setting up a work machine)

## MacOS Setup

The setup script will automatically install:

- Command Line Tools (if not present)
- Homebrew (if not present)
- Ansible (if not present)
- All other dependencies via the playbook

### Quick Start

On a fresh Mac, simply run:

```bash
# Clone this repo (macOS will prompt to install Command Line Tools if needed)
git clone https://github.com/DeanGaffney/environment-setup.git
cd environment-setup/macos

# Run the setup script
bash ./setup.sh
```

The script will guide you through the rest of the setup, prompting for:
- Machine type (work/personal)
- Git user information
- GitHub token

### What Gets Installed

- Development tools: git, curl, httpie, jq, ripgrep, fd, fzf
- Languages: Node.js (via nvm), Python (via pyenv), Java (via jenv), Go, Rust
- Editors: Neovim, VS Code, IntelliJ IDEA CE
- Terminal: Wezterm, tmux, oh-my-zsh
- Git tools: gh CLI, lazygit, git-delta
- Formatters/Linters: eslint_d, yamlfmt, shellcheck, codespell
- Build tools: Maven, CMake
- Other: Docker, AWS CLI, Kiro

See `playbook.yml` for the complete list.
