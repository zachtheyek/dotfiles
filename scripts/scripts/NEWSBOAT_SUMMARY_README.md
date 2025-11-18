# Newsboat Article Summary Viewer

A terminal-based application that fetches your newsboat articles, summarizes them with AI, and provides an interactive interface to browse summaries.

## Features

- Fetches articles from newsboat once daily at 6:00 AM
- Summarizes articles using Claude AI (cached daily to save API costs)
- Interactive terminal UI with keyboard navigation
- Jump to newsboat to read full articles
- Return to summary view seamlessly
- Restart or exit when finished

## Installation

1. Run the setup script:
```bash
./newsboat_summary_setup.sh
```

2. Set your Anthropic API key (if not already set):
```bash
export ANTHROPIC_API_KEY='your-api-key-here'
```

Add this to your `~/.zshrc` or `~/.bashrc` to make it permanent.

## Usage

### View Article Summaries
```bash
./newsboat_summary.py
```

### Navigation Keys

- **→ / l / Space** - Next article
- **← / h** - Previous article
- **o** - Open newsboat to read full article
- **q / Ctrl-C** - Quit to exit screen

### Exit Screen

- **r** - Restart from beginning
- **Any other key** - Exit application

## How It Works

1. **Scheduled Fetch**: Newsboat refreshes feeds daily at 6:00 AM via launchd
2. **First Run**: When you run the viewer for the first time each day, it:
   - Fetches all articles published today from newsboat's SQLite database
   - Summarizes each article using Claude AI
   - Caches the summaries in `~/.newsboat/summaries/`
3. **Subsequent Runs**: Uses cached summaries (no API calls)
4. **Next Day**: Cache expires, new articles are fetched and summarized

## Files

- `newsboat_summary.py` - Main application
- `newsboat_summary_setup.sh` - Setup script
- `com.newsboat.refresh.plist` - launchd configuration
- `~/.newsboat/summaries/` - Cache directory (auto-created)

## Manual Commands

### Refresh newsboat manually
```bash
newsboat --refresh-on-start
```

### View scheduled jobs
```bash
launchctl list | grep newsboat
```

### Check refresh logs
```bash
tail /tmp/newsboat-refresh.log
tail /tmp/newsboat-refresh.err
```

### Uninstall scheduled refresh
```bash
launchctl unload ~/Library/LaunchAgents/com.newsboat.refresh.plist
rm ~/Library/LaunchAgents/com.newsboat.refresh.plist
```

## Dependencies

- Python 3
- newsboat
- anthropic Python package
- Anthropic API key

## Cost Considerations

The application uses Claude 3.5 Haiku (cheap, fast model) for summaries:
- ~200 tokens per summary
- Cost: ~$0.001 per article (extremely cheap)
- Cached daily to prevent redundant API calls
- If you have 50 new articles per day: ~$0.05/day or ~$1.50/month

## Troubleshooting

### "No articles found for today"
Run `newsboat --refresh-on-start` to fetch new articles.

### "ANTHROPIC_API_KEY environment variable not set"
Set the API key in your shell configuration file.

### Scheduled refresh not working
Check launchd status:
```bash
launchctl list | grep newsboat
cat /tmp/newsboat-refresh.err
```

### Cache issues
Clear the cache:
```bash
rm -rf ~/.newsboat/summaries/
```

## Future Enhancements

- Filter by feed/tag
- Search summaries
- Export summaries to file
- Email daily digest
- TTS reading of summaries
