# dotfiles

Personal dotfiles with shell configurations and development tools.

## What's Included

- **Zsh Configuration**: Custom aliases and environment variables
- **Starship Prompt**: Modern, fast prompt with git integration
- **Color Scheme**: Nord color scheme for terminal applications
- **XDG Base Directory**: Organized configuration following XDG standards
- **Meta Package**: Automated Debian package for essential development tools

## Installation

### GitHub Codespaces

1. Clone this repository into your codespace:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/.dotfiles
   ./install.sh
   ```

3. Restart your shell or source your shell configuration:
   ```bash
   exec zsh
   ```

### Local Development

1. Clone this repository to your home directory:
   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
   ```

2. Make the installation script executable and run it:
   ```bash
   cd ~/.dotfiles
   chmod +x install.sh
   ./install.sh
   ```

3. Install the development tools meta-package (optional but recommended):
   ```bash
   # Install from the APT repository or GitHub releases
   # See Meta Package section below for installation instructions
   ```

4. Set zsh as your default shell (if not already):
   ```bash
   chsh -s $(which zsh)
   ```

5. Restart your terminal or source your shell configuration:
   ```bash
   exec zsh
   ```

## How It Works

The `install.sh` script:
- Creates XDG Base Directory structure (`~/.config`, `~/.local/share`, `~/.cache`)
- Symlinks configuration files from `config/` subdirectories to `~/.config/`
- Files with `.home` extension are symlinked to `$HOME` instead (e.g., `.zshenv.home` → `$HOME/.zshenv`)
- Preserves existing configurations by backing them up
- Supports easy updates by re-running the script

## Configuration Details

- **Zsh**: Configurations in `config/zsh/` directory
  - `config.zsh`: Environment variables and XDG paths
  - `alias.zsh`: Custom aliases
  - `history.zsh`: History configuration with Atuin integration
  - `nord.dircolors`: Nord color scheme for `ls`
- **Starship**: Prompt configuration in `config/starship/starship.toml`
- **Claude**: Claude Code settings in `config/claude/settings.json`

## Meta Package

The repository includes a Debian meta-package that automatically installs essential development tools:

### Included Tools
- `zsh`: Extended shell with advanced features
- `gh`: GitHub CLI tool
- `nano`: Simple text editor  
- `curl`: Command-line tool for transferring data
- `sudo`: Execute commands as another user
- `git`: Distributed version control system
- `ca-certificates`: Common CA certificates
- `starship`: Cross-shell prompt (recommended)

### Installation

#### Download from Releases
1. Go to the [Releases page](../../releases)
2. Download the latest `cglass-devenv_*.deb` file
3. Install with: `sudo dpkg -i cglass-devenv_*.deb`

#### Build Locally
```bash
cd packages/debian
./build-package.sh
sudo dpkg -i ../../cglass-devenv_*.deb
```

The package is automatically built and released when changes are pushed to the main branch.


## Updating

To update your dotfiles:
```bash
cd ~/.dotfiles
git pull
./install.sh
```