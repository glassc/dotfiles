export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

export EDITOR=nano

export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME}/npm"
export NPM_CONFIG_CACHE="${XDG_CACHE_HOME}/npm"
export NPM_CONFIG_PREFIX="${XDG_DATA_HOME}/npm"
export CLAUDE_CONFIG_DIR="${XDG_CONFIG_HOME}/claude"

export PATH=$PATH:${XDG_DATA_HOME}/npm/bin

export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"