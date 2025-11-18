#!/usr/bin/env python3
"""
Newsboat Article Summary Viewer

A terminal-based application that:
1. Fetches articles from newsboat (once per day)
2. Summarizes them using Claude API (cached daily)
3. Provides an interactive UI to browse summaries
4. Allows jumping to newsboat to read full articles
"""

import sqlite3
import json
import os
import sys
import subprocess
import signal
from datetime import datetime, date
from pathlib import Path
from typing import List, Dict, Optional
import anthropic


# Configuration
NEWSBOAT_CACHE = Path.home() / ".newsboat" / "cache.db"
SUMMARY_CACHE_DIR = Path.home() / ".newsboat" / "summaries"
SUMMARY_CACHE_DIR.mkdir(exist_ok=True)

# Terminal colors and formatting
class Colors:
    RESET = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'
    UNDERLINE = '\033[4m'

    BLACK = '\033[30m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    YELLOW = '\033[33m'
    BLUE = '\033[34m'
    MAGENTA = '\033[35m'
    CYAN = '\033[36m'
    WHITE = '\033[37m'

    BG_BLACK = '\033[40m'
    BG_WHITE = '\033[47m'
    BG_CYAN = '\033[46m'


class Article:
    """Represents a newsboat article"""
    def __init__(self, row: tuple):
        self.id = row[0]
        self.guid = row[1]
        self.title = row[2]
        self.author = row[3]
        self.url = row[4]
        self.feedurl = row[5]
        self.pubdate = datetime.fromtimestamp(row[6])
        self.content = row[7]
        self.feed_title = row[8] if len(row) > 8 else "Unknown Feed"
        self.summary = None

    def to_dict(self) -> Dict:
        return {
            'id': self.id,
            'guid': self.guid,
            'title': self.title,
            'author': self.author,
            'url': self.url,
            'feedurl': self.feedurl,
            'pubdate': self.pubdate.isoformat(),
            'feed_title': self.feed_title,
            'summary': self.summary
        }

    @classmethod
    def from_dict(cls, data: Dict) -> 'Article':
        # Create a mock tuple for initialization
        article = cls.__new__(cls)
        article.id = data['id']
        article.guid = data['guid']
        article.title = data['title']
        article.author = data['author']
        article.url = data['url']
        article.feedurl = data['feedurl']
        article.pubdate = datetime.fromisoformat(data['pubdate'])
        article.feed_title = data['feed_title']
        article.summary = data['summary']
        article.content = ""
        return article


def fetch_articles_from_newsboat() -> List[Article]:
    """Fetch articles from newsboat cache database"""
    if not NEWSBOAT_CACHE.exists():
        print(f"{Colors.RED}Error: Newsboat cache not found at {NEWSBOAT_CACHE}{Colors.RESET}")
        sys.exit(1)

    conn = sqlite3.connect(NEWSBOAT_CACHE)
    cursor = conn.cursor()

    # Get articles from today
    query = """
        SELECT
            i.id, i.guid, i.title, i.author, i.url, i.feedurl,
            i.pubDate, i.content, f.title as feed_title
        FROM rss_item i
        LEFT JOIN rss_feed f ON i.feedurl = f.rssurl
        WHERE i.deleted = 0
        AND date(i.pubDate, 'unixepoch') = date('now')
        ORDER BY i.pubDate DESC
    """

    cursor.execute(query)
    articles = [Article(row) for row in cursor.fetchall()]
    conn.close()

    return articles


def get_summary_cache_path() -> Path:
    """Get the cache file path for today's summaries"""
    today = date.today().isoformat()
    return SUMMARY_CACHE_DIR / f"summaries_{today}.json"


def load_cached_summaries() -> Optional[List[Article]]:
    """Load summaries from cache if they exist for today"""
    cache_path = get_summary_cache_path()

    if not cache_path.exists():
        return None

    try:
        with open(cache_path, 'r') as f:
            data = json.load(f)
            return [Article.from_dict(article_data) for article_data in data]
    except (json.JSONDecodeError, KeyError) as e:
        print(f"{Colors.YELLOW}Warning: Could not load cache: {e}{Colors.RESET}")
        return None


def save_summaries_to_cache(articles: List[Article]):
    """Save article summaries to cache"""
    cache_path = get_summary_cache_path()

    with open(cache_path, 'w') as f:
        json.dump([a.to_dict() for a in articles], f, indent=2)


def summarize_article(article: Article, client: anthropic.Anthropic) -> str:
    """Summarize an article using Claude API"""
    # Extract text from HTML content (basic)
    content_preview = article.content[:2000] if article.content else "No content available"

    prompt = f"""Summarize this news article in 2-3 concise sentences. Focus on the key facts and main points.

Title: {article.title}
Source: {article.feed_title}
Author: {article.author}
URL: {article.url}

Content preview:
{content_preview}

Provide a clear, informative summary:"""

    try:
        message = client.messages.create(
            model="claude-3-5-haiku-20241022",
            max_tokens=200,
            messages=[{"role": "user", "content": prompt}]
        )
        return message.content[0].text.strip()
    except Exception as e:
        return f"[Error summarizing: {str(e)}]"


def summarize_articles(articles: List[Article]) -> List[Article]:
    """Summarize all articles using Claude API"""
    api_key = os.getenv('ANTHROPIC_API_KEY')
    if not api_key:
        print(f"{Colors.RED}Error: ANTHROPIC_API_KEY environment variable not set{Colors.RESET}")
        print(f"{Colors.YELLOW}Please set it with: export ANTHROPIC_API_KEY='your-key-here'{Colors.RESET}")
        sys.exit(1)

    client = anthropic.Anthropic(api_key=api_key)

    print(f"\n{Colors.CYAN}Summarizing {len(articles)} articles...{Colors.RESET}")

    for i, article in enumerate(articles, 1):
        print(f"{Colors.DIM}[{i}/{len(articles)}] {article.title[:60]}...{Colors.RESET}", end='', flush=True)
        article.summary = summarize_article(article, client)
        print(f" {Colors.GREEN}✓{Colors.RESET}")

    return articles


def clear_screen():
    """Clear the terminal screen"""
    os.system('clear' if os.name != 'nt' else 'cls')


def display_article_summary(article: Article, current: int, total: int):
    """Display a single article summary"""
    clear_screen()

    # Header
    print(f"{Colors.BOLD}{Colors.CYAN}{'=' * 80}{Colors.RESET}")
    print(f"{Colors.BOLD}Article {current + 1} of {total}{Colors.RESET}")
    print(f"{Colors.CYAN}{'=' * 80}{Colors.RESET}\n")

    # Article info
    print(f"{Colors.BOLD}{Colors.YELLOW}{article.title}{Colors.RESET}")
    print(f"{Colors.DIM}Source: {article.feed_title}{Colors.RESET}")
    if article.author:
        print(f"{Colors.DIM}Author: {article.author}{Colors.RESET}")
    print(f"{Colors.DIM}Published: {article.pubdate.strftime('%Y-%m-%d %H:%M')}{Colors.RESET}")
    print(f"{Colors.DIM}URL: {article.url}{Colors.RESET}\n")

    # Summary
    print(f"{Colors.BOLD}Summary:{Colors.RESET}")
    print(f"{article.summary}\n")

    # Navigation help
    print(f"{Colors.CYAN}{'─' * 80}{Colors.RESET}")
    print(f"{Colors.GREEN}→/l/Space{Colors.RESET} Next  ", end='')
    print(f"{Colors.GREEN}←/h{Colors.RESET} Previous  ", end='')
    print(f"{Colors.GREEN}o{Colors.RESET} Open in newsboat  ", end='')
    print(f"{Colors.GREEN}q/Ctrl-C{Colors.RESET} Quit")
    print(f"{Colors.CYAN}{'─' * 80}{Colors.RESET}")


def open_in_newsboat(article: Article):
    """Open newsboat and navigate to the article"""
    # Save current terminal state
    subprocess.run(['stty', 'sane'])

    # Open newsboat - it will show all feeds
    # Unfortunately newsboat doesn't have a direct "open this URL" command
    # So we'll just open newsboat and the user can navigate to it
    try:
        subprocess.run(['newsboat'], check=False)
    except KeyboardInterrupt:
        pass

    # Restore terminal
    subprocess.run(['stty', 'sane'])


def get_keypress() -> str:
    """Get a single keypress from the user"""
    import termios
    import tty

    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        ch = sys.stdin.read(1)

        # Handle arrow keys (escape sequences)
        if ch == '\x1b':
            next1 = sys.stdin.read(1)
            if next1 == '[':
                next2 = sys.stdin.read(1)
                if next2 == 'C':  # Right arrow
                    return 'right'
                elif next2 == 'D':  # Left arrow
                    return 'left'

        return ch
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)


def run_summary_viewer(articles: List[Article]):
    """Main interactive viewer loop"""
    if not articles:
        print(f"{Colors.YELLOW}No articles to display.{Colors.RESET}")
        return

    current_index = 0

    # Set up signal handler for Ctrl-C
    def signal_handler(sig, frame):
        raise KeyboardInterrupt

    signal.signal(signal.SIGINT, signal_handler)

    try:
        while True:
            display_article_summary(articles[current_index], current_index, len(articles))

            key = get_keypress()

            if key in ['q', '\x03']:  # q or Ctrl-C
                raise KeyboardInterrupt
            elif key in ['right', 'l', ' ']:  # Next
                if current_index < len(articles) - 1:
                    current_index += 1
                else:
                    # At the end
                    raise KeyboardInterrupt
            elif key in ['left', 'h']:  # Previous
                if current_index > 0:
                    current_index -= 1
            elif key == 'o':  # Open in newsboat
                open_in_newsboat(articles[current_index])

    except KeyboardInterrupt:
        # Show exit screen
        clear_screen()
        print(f"\n{Colors.BOLD}{Colors.CYAN}Summary viewing complete!{Colors.RESET}\n")
        print(f"{Colors.GREEN}r{Colors.RESET} - Restart from beginning")
        print(f"{Colors.GREEN}Any other key{Colors.RESET} - Exit\n")

        choice = get_keypress()
        if choice == 'r':
            run_summary_viewer(articles)


def main():
    """Main entry point"""
    clear_screen()
    print(f"{Colors.BOLD}{Colors.CYAN}Newsboat Article Summary Viewer{Colors.RESET}\n")

    # Check for cached summaries first
    print(f"{Colors.DIM}Checking for cached summaries...{Colors.RESET}")
    articles = load_cached_summaries()

    if articles:
        print(f"{Colors.GREEN}✓ Found {len(articles)} cached summaries from today{Colors.RESET}")
    else:
        print(f"{Colors.YELLOW}No cached summaries found. Generating new summaries...{Colors.RESET}\n")

        # Fetch articles from newsboat
        print(f"{Colors.DIM}Fetching articles from newsboat...{Colors.RESET}")
        articles = fetch_articles_from_newsboat()

        if not articles:
            print(f"{Colors.YELLOW}No articles found for today.{Colors.RESET}")
            print(f"{Colors.DIM}Run 'newsboat --refresh-on-start' to fetch new articles.{Colors.RESET}")
            return

        print(f"{Colors.GREEN}✓ Found {len(articles)} articles{Colors.RESET}")

        # Summarize articles
        articles = summarize_articles(articles)

        # Cache the summaries
        print(f"\n{Colors.DIM}Caching summaries...{Colors.RESET}")
        save_summaries_to_cache(articles)
        print(f"{Colors.GREEN}✓ Summaries cached{Colors.RESET}\n")

    # Run the interactive viewer
    print(f"{Colors.DIM}Starting viewer...{Colors.RESET}\n")
    import time
    time.sleep(1)

    run_summary_viewer(articles)

    # Final cleanup
    clear_screen()
    print(f"{Colors.GREEN}Thanks for reading! Goodbye.{Colors.RESET}\n")


if __name__ == "__main__":
    main()
