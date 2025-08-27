
# Source all .zsh files in the zsh directory
for file in ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/*.zsh; do
    if [[ -r "$file" ]]; then
        source "$file"
    fi
done

eval `dircolors "${XDG_CONFIG_HOME}/zsh/nord.dircolors"`

eval "$(starship init zsh)"
