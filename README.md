# dotfiles

Personal dotfiles with shell configurations and development tools.

## What's Included

- **Zsh Configuration**: Custom aliases and environment variables
- **Starship Prompt**: Modern, fast prompt with git integration
- **Color Scheme**: Nord color scheme for terminal applications
- **XDG Base Directory**: Organized configuration following XDG standards

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

3. Install required dependencies:
   - **Zsh**: Your shell (usually pre-installed on macOS/Linux)
   - **Starship**: Cross-shell prompt
     ```bash
     # macOS
     brew install starship
     
     # Linux
     curl -sS https://starship.rs/install.sh | sh
     ```
   - **Atuin**: Shell history replacement (optional)
     ```bash
     # macOS
     brew install atuin
     
     # Linux
     curl --proto '=https' --tlsv1.2 -sSf https://setup.atuin.sh | sh
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
- Symlinks configuration files from each directory to `~/.config/`
- Files with `.home` extension are symlinked to `$HOME` instead (e.g., `.zshenv.home` → `$HOME/.zshenv`)
- Preserves existing configurations by backing them up
- Supports easy updates by re-running the script
- Uses `.dotfilesIgnore` to skip directories and files during installation

## Configuration Details

- **Zsh**: Configurations in `zsh/` directory
  - `config.zsh`: Environment variables and XDG paths
  - `alias.zsh`: Custom aliases
  - `history.zsh`: History configuration with Atuin integration
  - `nord.dircolors`: Nord color scheme for `ls`
- **Starship**: Prompt configuration in `starship/starship.toml`
- **Claude**: Claude Code settings in `claude/settings.json`

## Installation Control

The `.dotfilesIgnore` file allows you to specify directories and files that should be skipped during installation:

```
# Directories to ignore during installation
.devcontainer/
.git/
.github/
node_modules/
.vscode/
.idea/

# Files to ignore
*.log
*.tmp
.DS_Store
README.md
install.sh
.gitignore
.dotfilesIgnore
```

The installation script will read this file and skip any directories or files that match the patterns listed.

## Updating

To update your dotfiles:
```bash
cd ~/.dotfiles
git pull
./install.sh
```