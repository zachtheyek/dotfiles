This repository relies on [GNU Stow](https://www.gnu.org/software/stow/) to centralize, manage, and distribute dotfiles across your machine. Each package is tied to a tool (or set of tools), and lives in its own directory that mimics the expected configuration structure relative to `$HOME`. When invoked, Stow will create symlinks to the specified packages in this repository throughout your machine, such that each tool may function as normal, while retaining a unified control hub for the user. Once setup, it's recommended you make edits to the configs directly from the repository itself, rather than through the symlinks, to avoid artifacts that become out-of-sync over time. Naturally, you'll need to have a given tool installed beforehand for the corresponding package to take effect (usually just `brew install X`;  refer to the official docs for further instruction). 

> [!NOTE]
> All packages are configured to my personal liking, and are highly opinionated & biased. My general philosophy, in descending order of importance: 
> 
>  - Keyboard-first, with a strong preference for vim bindings, CLIs, and TUIs
>    - The less time I spend thinking about where to place my fingers, or what app I need to go to, the more time I spend actually coding
>  - Clean & consistent UI > ricing potential
>    - Everything is optimized for a single 27" 4k 120Hz monitor (I don't believe in any other monitor setup). The limited real estate forces me to declutter
>    - Space should be filled intentionally. Consistency reduces visual fatigue
>  - UNIX principle: tools should do one thing well
>    - I generally don't like all-in-one solutions, though it's not necessarily a strict boundary
>    - Bonus points if the tool is open-source, community-driven, and well-maintained
>  - macOS only, I don't particularly care about cross-platform compatibility in my tool selection
>    - Linux is really cool, it just lacks some core features/software that I've come to rely on
>      - Though I'm actively working on an Arch Linux port, so stay tuned for that!
>    - Windows is ass from a butt :/

# Installation

## Prerequisites

Assuming you have git and homebrew on your machine, 

1. **Install GNU Stow**:
   ```bash
   brew install stow
   ```

2. **Clone this repository**:
   ```bash
   git clone <repository-url> ~/dotfiles
   cd ~/dotfiles
   ```

3. **Make the install script executable**:
   ```bash
   chmod +x install.sh
   ```

## Usage

The installation script supports four commands:

| Command | Description |
|:--------|:------------|
| `stow` | Create symlinks |
| `unstow` | Remove symlinks |
| `restow` | Update symlinks (remove + create) (`default`) |
| `dry-run` | Show what would happen without making changes |


Each command can be followed up with a space-separated list of packages to be operated on. If none are provided, all packages will be selected by default. 

**Examples:**

```bash
# Restow all packages (default)
./install.sh

# Stow all packages
./install.sh stow

# Stow specific packages
./install.sh stow aerospace nvim zsh

# Unstow specific packages
./install.sh unstow tmux

# Restow specific packages (useful after git pull)
./install.sh restow zsh

# Preview changes without applying them
./install.sh dry-run
./install.sh dry-run nvim zsh
```

## Post-Installation

Note that some tools require additional setup. For example:

1. **Tmux plugins**: Open tmux and press `<prefix>+I` to install plugins via TPM
2. **Neovim plugins**: Open nvim and run `:Lazy sync` to install plugins via Lazy
3. **Karabiner-Elements**: Grant accessibility permissions in System Settings

etc.

Please reference the official docs if you're having trouble setting up a specific tool.

Further, if you'd like to add your own package: 

1. Create a new directory in this repository with the package name
2. Add your config files in the same structure as they appear in `$HOME`
3. Run `./install.sh stow <package-name>` to symlink it

Example:
```bash
mkdir -p my-tool/.config/my-tool
echo "config=true" > my-tool/.config/my-tool/config.toml
./install.sh stow my-tool
```

I found this [video](https://www.youtube.com/watch?v=dQw4w9WgXcQ)[^1] to be especially helpful for understanding the underlying workflow.

# Troubleshooting

**Stow conflicts**: If stow reports conflicts, you may need to back up existing configs:
```bash
mv ~/.config/nvim ~/.config/nvim.backup
./install.sh nvim
```

**Broken symlinks**: To fix broken symlinks after moving the repo:
```bash
./install.sh restow
```

**Check what would happen**: Always test with dry-run first:
```bash
./install.sh dry-run
```

# Package Overview

## Window Management & UI

| Tool | Description | Source |
|:-----|:------------|:-------|
| Aerospace | i3-inspired tiling window manager for macOS | [nikitabobko/AeroSpace](https://github.com/nikitabobko/AeroSpace) |
| Sketchybar | Highly customizable macOS menu bar replacement | [FelixKratz/SketchyBar](https://github.com/FelixKratz/SketchyBar) |
| Karabiner | Powerful keyboard remapping for macOS | [pqrs-org/Karabiner-Elements](https://github.com/pqrs-org/Karabiner-Elements) |


## Shell & Terminal

| Tool | Description | Source |
|:-----|:------------|:-------|
| Ghostty | Fast, native, GPU-accelerated terminal emulator | [ghostty-org/ghostty](https://github.com/ghostty-org/ghostty) |
| iTerm2 | Feature-rich terminal emulator for macOS | [gnachman/iTerm2](https://github.com/gnachman/iTerm2) |
| Zsh | Interactive shell with extensive customization | [zsh-users/zsh](https://github.com/zsh-users/zsh) |
| Tmux | Terminal multiplexer + management for sessions, windows, and panes | [tmux/tmux](https://github.com/tmux/tmux) |
| Envman | Centralized management of shell variables, aliases, and functions | [bitrise-io/envman](https://github.com/bitrise-io/envman) |


## File Management & Navigation

| Tool | Description | Source |
|:-----|:------------|:-------|
| Yazi | Modern TUI file manager with image previews | [sxyazi/yazi](https://github.com/sxyazi/yazi) |
| Fzf | Interactive fuzzy search for files, commands, and more | [junegunn/fzf](https://github.com/junegunn/fzf) |
| Zoxide | Smarter `cd` that learns your habits | [ajeetdsouza/zoxide](https://github.com/ajeetdsouza/zoxide) |
| Eza | Enhanced `ls` with icons and git integration | [eza-community/eza](https://github.com/eza-community/eza) |


## Text Editing & Viewing

| Tool | Description | Source |
|:-----|:------------|:-------|
| Neovim | Hyperextensible Vim-based text editor | [neovim/neovim](https://github.com/neovim/neovim) |
| Sioyek | Keyboard-focused PDF reader optimized for academic work | [ahrm/sioyek](https://github.com/ahrm/sioyek) |
| Bat | Enhanced `cat` with syntax highlighting | [sharkdp/bat](https://github.com/sharkdp/bat) |


## Development Tools

| Tool | Description | Source |
|:-----|:------------|:-------|
| Git | Distributed version control system | [git/git](https://github.com/git/git) |
| GitHub CLI (gh) | Official GitHub command-line tool | [cli/cli](https://github.com/cli/cli) |
| SSH | Secure shell configuration for remote access and authentication | |


## System Monitoring

| Tool | Description | Source |
|:-----|:------------|:-------|
| Btop | Beautiful terminal-based system monitor | [aristocratos/btop](https://github.com/aristocratos/btop) |
| Htop | Interactive process monitoring tool | [htop-dev/htop](https://github.com/htop-dev/htop) |
| S-tui | CPU monitoring and stress testing | [amanusk/s-tui](https://github.com/amanusk/s-tui) |
| Fastfetch | `Neofetch` alternative with faster performance | [fastfetch-cli/fastfetch](https://github.com/fastfetch-cli/fastfetch) |
| Neofetch | System information tool with ASCII art | [dylanaraps/neofetch](https://github.com/dylanaraps/neofetch) |


## Productivity & Utilities

| Tool | Description | Source |
|:-----|:------------|:-------|
| iCalBuddy | macOS calendar integration inside terminal and tmux | [ali-rantakari/icalBuddy](https://github.com/ali-rantakari/icalBuddy) |
| Thefuck | Auto-correct mistyped commands | [nvbn/thefuck](https://github.com/nvbn/thefuck) |
| yt-dlp | Download videos from YouTube and other platforms | [yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp) |
| Scripts | Personal collection of maintenance and utility scripts | |


# Security Note

Sensitive files were either sanitized, or completely excluded via `.gitignore`. This includes, but is not limited to, API keys/tokens, SSH public-private key pairs, sensitive environment variables, passwords, etc. 

> [!CAUTION]
> If you choose to share your own dotfiles publicly -- be very careful what you commit to version control! Rotate your secrets & amend the logs ASAP if something goes wrong.

> [!TIP]
> Use [gitleaks](https://github.com/gitleaks/gitleaks) as a pre-commit hook and CI/CD action to automate the scanning of your repo for leaked secrets. See `.github/workflows/gitleaks.yml` & `.pre-commit-config.yaml`.

# License

These are personal configurations. Feel free to use, modify, and adapt them for your own needs.

# Acknowledgments

Configurations inspired by the broader open-source & dotfiles community. Special thanks to:
- NVChad for the excellent Neovim framework
- The Catppuccin team for the beautiful & extensible color scheme
- The GNU Stow maintainers for the simple yet powerful tool
- And YouTubers [@Josean Martinez](https://www.youtube.com/@joseanmartinez), [@DevOps Toolbox](https://www.youtube.com/@devopstoolbox), and [@typecraft](https://www.youtube.com/@typecraft_dev) (among others) for their extensive content libraries that inspired much of this work

[^1]: jk lol, here you go: https://youtu.be/y6XCebnB9gs?si=APiYpB2Mvqn-gcA3
