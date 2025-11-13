#!/bin/bash
# Seamless dotfile management with GNU stow + shell scripting
#
# Usage:
#   ./install.sh [command] [packages...]
#
# Commands:
#   stow      Create symlinks
#   unstow    Remove symlinks
#   restow    Update symlinks (default)
#   dry-run   Show what would happen
#
# Packages: 
#   list directory names, each separated by a space
#   leave empty to select all (default)
#
# Examples:
#   ./install.sh                            # restow all packages (default)
#   ./install.sh stow                       # stow all packages
#   ./install.sh unstow aerospace nvim      # unstow only aerospace and nvim
#   ./install.sh restow zsh                 # restow only zsh
#   ./install.sh dry-run tmux               # dry-run for tmux only
# 
# Note, if it's your first run, don't forget to make the script executable: chmod +x install.sh

set -e
cd "$(dirname "$0")" || exit 1

# Auto-discover all packages (directories in cwd)
# Automatically ignores hidden directories (e.g. .git or .claude)
get_all_packages() {
    local packages=()
    for dir in */; do
        # Remove trailing slash
        packages+=("${dir%/}")
    done
    echo "${packages[@]}"
}

ALL_PACKAGES=($(get_all_packages))

# Parse first argument as command if it matches known commands
COMMAND="restow"
PACKAGES=()

if [[ "$1" =~ ^(stow|unstow|restow|dry-run)$ ]]; then
    COMMAND="$1"
    shift
fi

# Remaining arguments are packages, or use all if none specified
if [ $# -eq 0 ]; then
    PACKAGES=("${ALL_PACKAGES[@]}")
else
    PACKAGES=("$@")
fi

# Map command to stow flags
case "$COMMAND" in
    stow)
        STOW_CMD="stow -S"
        ACTION_VERB="Stowing"
        ;;
    unstow)
        STOW_CMD="stow -D"
        ACTION_VERB="Unstowing"
        ;;
    restow)
        STOW_CMD="stow -R"
        ACTION_VERB="Restowing"
        ;;
    dry-run)
        STOW_CMD="stow -n -v"
        ACTION_VERB="Dry-run for"
        ;;
esac

# Execute stow for each package
TOTAL_PACKAGES=${#PACKAGES[@]}
echo "$ACTION_VERB $TOTAL_PACKAGES package(s): ${PACKAGES[*]}"
echo ""

FAILED=()
SUCCESS=0

for pkg in "${PACKAGES[@]}"; do
    if [ ! -d "$pkg" ]; then
        echo "  ✗ $pkg (directory not found)"
        FAILED+=("$pkg")
        continue
    fi
    
    echo "  → $pkg"
    if $STOW_CMD "$pkg" 2>&1 | grep -v "BUG in find_stowed_path" || true; then
        echo "    ✓ Success"
        ((SUCCESS++))
    else
        echo "    ✗ Failed"
        FAILED+=("$pkg")
    fi
done

echo ""

# Summary
FAILED_COUNT=${#FAILED[@]}
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Summary: $SUCCESS succeeded, $FAILED_COUNT failed (out of $TOTAL_PACKAGES total)"

if [ $FAILED_COUNT -eq 0 ]; then
    echo "✓ All packages processed successfully"
    exit 0
else
    echo "✗ Failed packages: ${FAILED[*]}"
    exit 1
fi
