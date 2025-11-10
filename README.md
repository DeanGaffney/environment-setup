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

On a fresh Mac, run this one-liner:

```bash
mkdir -p ~/workspace/personal && cd ~/workspace/personal && git clone https://github.com/DeanGaffney/environment-setup.git && cd environment-setup/macos && bash ./setup.sh
```

Or step by step:

```bash
# Create workspace directory structure
mkdir -p ~/workspace/personal
cd ~/workspace/personal

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

### Running Specific Tasks

You can run specific parts of the setup using tags:

```bash
cd environment-setup/macos

# Only install Homebrew packages
ansible-playbook -i inventory playbook.yml --tags homebrew

# Only setup programming languages (Java, Node, Python)
ansible-playbook -i inventory playbook.yml --tags languages

# Only setup git and SSH
ansible-playbook -i inventory playbook.yml --tags git,ssh

# Only setup work-specific configuration
ansible-playbook -i inventory playbook.yml --tags work

# Skip certain tasks
ansible-playbook -i inventory playbook.yml --skip-tags homebrew
```

Available tags:

- `prerequisites` - Basic tools (git, curl, etc.)
- `workspace` - Workspace directories
- `dotfiles` - Dotfiles setup
- `shell`, `zsh` - Shell configuration
- `homebrew` - Homebrew packages and casks
- `languages` - Java, Node, Python setup
- `java`, `nodejs`, `python` - Individual languages
- `dev-tools` - tmux, neovim
- `config` - Config files (maven, pip, npm)
- `git`, `ssh` - Git and SSH setup
- `work` - Work-specific tasks

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
