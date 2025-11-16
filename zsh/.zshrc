# TODO: split aliases into a separate file & source from .zshrc

### Interactive shell config (prompt, aliases, plugins, etc.)

# Login hook: run fastfetch on new shell startup
# Uncomment to activate (note: gets triggered more often than you think)
# fastfetch

# Instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh" # Path to oh-my-zsh installation
ZSH_THEME="powerlevel10k/powerlevel10k" # Set theme
ENABLE_CORRECTION="true" # Enable command auto-correction
HIST_STAMPS="yyyy-mm-dd" # Set date format

# Set Neovim as preferred editor
export EDITOR="nvim" 
alias n="nvim"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Set Sioyek alias 
alias yek="sioyek"

# Set icalBuddy alias 
alias cal="icalBuddy"

# Load plugins
plugins=(
    web-search               # Search aliases
    git                      # Git aliases & functions
    git-commit               # Git-commit aliases
    git-lfs                  # Git-lfs aliases & functions
    gitfast                  # Git autocompletion
    docker                   # Docker aliases & auto-completion
    docker-compose           # Docker-compose aliases & Auto-completion
    conda                    # Conda aliases 
    dbt                      # dbt aliases 
    zsh-vi-mode              # Enable Vim motions 
    # zsh-autopair             # Auto-close delimiters
    zsh-autosuggestions      # Auto-completion
    zsh-syntax-highlighting  # Syntax highlighting
    fzf-zsh-plugin           # Fuzzy finder
)
source $ZSH/oh-my-zsh.sh

### TODO: fix zsh-vi-mode & zsh-autopair integration
### NOTE: how to sync zsh-vi-mode yank with system clipboard?
# Reinitialize zsh-vi-mode cleanly if re-sourcing
if [[ -n $ZSH_VERSION && -o zle ]]; then
  bindkey -v
  zle -A vi-insert self-insert
  zvm_init
fi

# Set up git wrapper for working with GitHub CLI
eval "$(hub alias -s)"

### TODO: fix fzf (begin)
# Set up fzf key bindings & fuzzy completion
eval "$(fzf --zsh)"
# alias f="fzf"

# Set fzf theme
source ~/.config/fzf/fzf-theme.sh/themes/catppuccin-fzf-mocha.sh

# Remap fzf to use fd by default
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git"
# export FZF_DEFAULT_OPTS="--height=40% --layout=default --border"
# export FZF_CTRL_T_OPTS="--height=40% --preview='bat ---style=numbers -color=always --line-range=:500 {}'"
# export FZF_ALT_C_OPTS="--height=40% --preview='eza -a --git --group-directories-first --tree --level 1 --no-quotes --color=always --icons=always {}'"

_fzf_compgen_path() {   # Use fd to list path candidates
    fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {   # Use fd to generate directory completion list
    fd --type=d --hidden --exclude .git . "$1"
}

# # Enable previews when using fzf
# show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"
# _fzf_comprun() {
#   local command=$1
#   shift
#
#   case "$command" in
#     cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
#     export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
#     ssh)          fzf --preview 'dig {}'                   "$@" ;;
#     *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
#   esac
# }

# fzf<>nvim (rename alias name?)
# list_oldfiles() {
#     # Get the oldfiles list from Neovim
#     local oldfiles=($(nvim -u NONE --headless +'lua io.write(table.concat(vim.v.oldfiles, "\n") .. "\n")' +qa))
#     # Filter invalid paths or files not found
#     local valid_files=()
#     for file in "${oldfiles[@]}"; do
#         if [[ -f "$file" ]]; then
#             valid_files+=("$file")
#         fi
#     done
#     # Use fzf to select from valid files
#     local files=($(printf "%s\n" "${valid_files[@]}" | \
#         grep -v '\[.*' | \
#         fzf --multi \
#         --preview 'bat -n --color=always --line-range=:500 {} 2>/dev/null || echo "Error previewing file"' \
#         --height=70% \
#         --layout=default))
#
#   # Open selected files in Neovim
#   [[ ${#files[@]} -gt 0 ]] && nvim "${files[@]}"
# }
# # Call the function
# list_oldfiles "$@"
# # set to an alias nlof in .zshrc
# alias nlof="list_oldfiles()"

# fzf<>tmux
# export FZF_TMUX_OPTS=" -p90%,70%" ### idk what this does yet??

# Source additional fzf<>git functions & key bindings
source ~/.config/fzf/fzf-git.sh/fzf-git.sh  # NOTE: how do i use this again? 

# opens documentation through fzf (eg: git,zsh etc.) (plays well with tldr)
# alias fman="compgen -c | fzf | xargs man"

# # Define fzf<>mv to fuzzy find target file & directory
# imv() { 
#   src=$(fzf --height=40% --preview 'bat --style=numbers --color=always {} 2>/dev/null' --prompt="Select file to move: ")
#   [ -z "$src" ] && echo "No source selected" && return 1
#
#   dest=$(fd . --type d --hidden --follow --exclude .git | fzf --height=40% --preview 'eza -a --git --group-directories-first --tree --level 1 --no-quotes --color=always --icons=always' --prompt="Select destination directory: ")
#   if [ -z "$dest" ]; then
#     echo "No destination selected."
#     read "use_cwd?Move to current working directory instead? (y/n): "
#     if [[ "$use_cwd" == [yY] ]]; then
#       dest="."
#     else
#       echo "Move cancelled."
#       return 1
#     fi
#   fi
#
#   mv "$src" "$dest/"
# }

# Define fzf<>Aerospace function to find & switch windows 
ff() {
  aerospace list-windows --all | \
    fzf --height=40% --bind "enter:execute-silent(aerospace focus --window-id {1})+abort"
}
### TODO: fix fzf (end)

# Prefer fd over find
alias find="fd"

# Prefer ripgrep over grep
alias grep="rg"

# Yazi setup 
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Lazygit setup
lg()
{
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# Set up thefuck (auto-correction for mistyped commands)
eval $(thefuck --alias tf)

# Set up bat (better cat)
export BAT_THEME="Catppuccin Mocha"

# Set up eza (better ls)
alias ls="eza --git --group-directories-first --tree --level 1 --no-quotes --color=always --icons=always"
alias la="eza -a --git --group-directories-first --tree --level 1 --no-quotes --color=always --icons=always"
alias ll="eza -l --no-user --smart-group --no-time --git --group-directories-first --tree --level 1 --no-quotes --color=always --icons=always"
alias lla="eza -l -a --no-user --smart-group --no-time --git --group-directories-first --tree --level 1 --no-quotes --color=always --icons=always"

# Set up zoxide (better cd)
eval "$(zoxide init --cmd cd zsh)"

# Redirect less history write path 
export LESSHISTFILE="$HOME/.local/state/less/history"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# TODO: figure out how to actually use bitwarden-cli effectively, or whether we should migrate to pass
# Bitwarden CLI configs
# NOTE: if we need bw creds in scripts/non-interactive contexts, move load_keychain_secrets to .zshenv
load_keychain_secrets() {
  local secrets_list=(
    "bw_clientid:BW_CLIENTID"
    "bw_clientsecret:BW_CLIENTSECRET"
    "bw_password:BW_PASSWORD"
  )

  for entry in "${secrets_list[@]}"; do
    local service_name="${entry%%:*}"   # text before colon
    local env_name="${entry##*:}"       # text after colon
    local value

    # Fetch secrets silently from keychain
    value=$(security find-generic-password -s "$service_name" -w 2>/dev/null)
    # Store as environment variables
    export "$env_name=$value"
  done
}

# BUG: 
# Suppress output to avoid "value=..." exposing our secrets every time .zshrc is sourced
# Root cause unknown - likely oh-my-zsh plugin or shell hook intercepting exports
# Will assume it works without issue otherwise for now
load_keychain_secrets >/dev/null 2>&1

alias bw_up="bw login --apikey && bw unlock --passwordenv BW_PASSWORD"
alias bw_down="bw lock && bw logout"
alias bw_retry="bw lock && bw logout && bw login --apikey && bw unlock --passwordenv BW_PASSWORD"

# Kubernetes configs
source <(kubectl completion zsh)

# NOTE: how do i use this again?
# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Conda configs
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/zach/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
elif [ -f "/Users/zach/opt/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/zach/opt/miniconda3/etc/profile.d/conda.sh"
fi
unset __conda_setup
# <<< conda initialize <<<

# TODO: add conda tab auto-completion functionality
# # Conda tab autocompletion
# if command -v conda &>/dev/null; then
#     # Enable Bash-style completion in Zsh
#     autoload -U +X bashcompinit && bashcompinit
#
#     # Load Conda’s own Bash completion definitions
#     source <(conda shell.bash completion 2>/dev/null)
#     compdef _conda conda
# fi

# Opam configs
# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/Users/zach/.opam/opam-init/init.zsh' ]] || source '/Users/zach/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/zach/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/zach/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/zach/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/zach/google-cloud-sdk/completion.zsh.inc'; fi

# Claude code setup
alias claude="/Users/zach/.claude/local/claude"
