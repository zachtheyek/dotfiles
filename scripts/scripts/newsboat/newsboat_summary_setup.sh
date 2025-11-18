#!/usr/bin/env bash
# Setup script for Newsboat Summary Viewer

set -e

echo "=================================="
echo "Newsboat Summary Viewer - Setup"
echo "=================================="
echo

# Check if newsboat is installed
if ! command -v newsboat &> /dev/null; then
    echo "Error: newsboat is not installed"
    echo "Install with: brew install newsboat"
    exit 1
fi

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed"
    exit 1
fi

# Install required Python packages
echo "Installing Python dependencies..."
pip3 install anthropic --quiet

# Check for API key
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo
    echo "Warning: ANTHROPIC_API_KEY environment variable is not set"
    echo "You'll need to set this for the summarization to work."
    echo
    echo "Add this to your ~/.zshrc or ~/.bashrc:"
    echo "  export ANTHROPIC_API_KEY='your-api-key-here'"
    echo
fi

# Set up launchd for daily newsboat refresh at 6am
echo
echo "Setting up daily newsboat refresh at 6:00 AM..."
PLIST_SRC="$(dirname "$0")/com.newsboat.refresh.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/com.newsboat.refresh.plist"

mkdir -p "$HOME/Library/LaunchAgents"
cp "$PLIST_SRC" "$PLIST_DEST"

# Load the launchd job
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "✓ Scheduled newsboat to refresh daily at 6:00 AM"

# Create summary cache directory
mkdir -p "$HOME/.newsboat/summaries"

echo
echo "=================================="
echo "Setup Complete!"
echo "=================================="
echo
echo "Usage:"
echo "  1. Run 'newsboat_summary.py' anytime to view article summaries"
echo "  2. Newsboat will auto-refresh at 6:00 AM daily"
echo "  3. First run of the day will generate summaries (uses API)"
echo "  4. Subsequent runs will use cached summaries (free)"
echo
echo "Manual refresh:"
echo "  newsboat --refresh-on-start"
echo
echo "View summaries:"
echo "  ./newsboat_summary.py"
echo
echo "Uninstall scheduled refresh:"
echo "  launchctl unload ~/Library/LaunchAgents/com.newsboat.refresh.plist"
echo "  rm ~/Library/LaunchAgents/com.newsboat.refresh.plist"
echo
