# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Essential Commands

### Package Management
- **Build Debian Package**: `cd packages/debian && ./build-package.sh`
- **Local Package Install**: `sudo dpkg -i cglass-devenv_*.deb`

### Dotfiles Management  
- **Install/Update Dotfiles**: `./install.sh` (symlinks configs, safe to re-run)
- **Test Configuration Changes**: `exec zsh` (reload shell to apply changes)

### Development Workflow
- **Validate Changes**: Re-run `./install.sh` after config modifications
- **Package Testing**: Build package locally before pushing to test packaging changes

## Architecture Overview

### XDG Base Directory System
The repository implements a strict XDG Base Directory specification with a dual-symlink strategy:

- **Regular files**: Symlinked from `config/[tool]/` to `$XDG_CONFIG_HOME/[tool]/`
- **`.home` extension files**: Special files that strip the `.home` suffix and symlink to `$HOME/`

Configuration loading chain:
1. `.zshenv` (from `.zshenv.home`) sets up XDG environment variables
2. `config.zsh` configures tool-specific paths and environment
3. `.zshrc` loads all zsh configs and initializes external tools
4. Tools load configurations from XDG-compliant paths

### GitHub Pages PPA Workflow
The repository functions as a Personal Package Archive (PPA) hosted on GitHub Pages:

**Domain**: `dotfiles.chrisglass.dev` (configured via `docs/CNAME`)

**Automated Build/Deploy Process**:
1. Push/PR to main/master triggers GitHub Actions workflow
2. `build-debian-package.yml` builds the `cglass-devenv` meta-package
3. Package files are automatically committed back to repository in proper APT structure (`docs/packages/debian/`)
4. GitHub Pages serves the APT repository with GPG signing

**APT Repository Structure**:
```
docs/packages/debian/
├── dists/stable/           # Release metadata
│   ├── Release
│   └── main/binary-all/
│       └── Packages        # Package index
└── pool/                   # Actual .deb files
```

### Meta-Package System
The `cglass-devenv` Debian package is a meta-package that declares dependencies on essential development tools:
- Core: `zsh`, `git`, `curl`, `sudo`, `nano`, `ca-certificates`  
- Development: `gh` (GitHub CLI)
- Enhancements: `starship` (prompt), `atuin` (shell history)

## Key Development Patterns

### Configuration Organization
- Each tool has its own subdirectory in `config/`
- Modular zsh configuration with separate files for aliases, environment, and history
- Tool-specific environment variables centralized in `config.zsh`

### Installation Philosophy
- **Non-destructive**: Removes existing symlinks/files before creating new ones
- **Atomic updates**: Symlinks updated atomically (remove old, create new)
- **XDG-compliant**: All configurations follow XDG Base Directory specification
- **Version controlled**: All configurations tracked in git for easy rollback

### Validation Strategy
- No traditional unit tests (meta-package has no code to test)
- Validation occurs through successful package builds
- Installation script is idempotent and safe to re-run
- Shell reload required to test configuration changes

## Repository-Specific Context

### Making Changes
- **Config modifications**: Edit files in `config/` directories, then run `./install.sh`
- **Package updates**: Modify `packages/debian/control` for dependencies, build locally to test
- **PPA updates**: Changes to package configuration automatically trigger PPA rebuilds on push

### Testing Workflow
- Configuration changes are immediately reflected via symlinks after running `install.sh`
- Package changes should be built locally first: `cd packages/debian && ./build-package.sh`
- Shell configuration requires `exec zsh` to reload and test changes
- PPA functionality can be tested by adding the repository and installing the package

### Build System Notes
- GitHub Actions runs on Ubuntu latest with `debhelper`, `devscripts`, `build-essential`
- Package artifacts are retained for 30 days in GitHub Actions
- No complex build tools required - simple shell scripts handle packaging
- APT repository structure maintained automatically by the build process

### Environment Compatibility
- Designed for GitHub Codespaces and local development environments
- Works on Debian/Ubuntu systems via the PPA
- XDG Base Directory specification ensures clean configuration management
- Cross-platform shell configurations with environment detection