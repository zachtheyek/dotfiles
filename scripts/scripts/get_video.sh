#!/usr/bin/env bash
set -euo pipefail

readonly PROG=${0##*/}
ytdlp=${YTDLP_BIN:-yt-dlp}

usage() {
    cat <<EOF
Usage: $PROG [options]                # paste/enter URLs interactively
       $PROG [options] FILE.txt ...   # read URLs from text file(s)
       $PROG [options] URL ...        # URLs as args (quote ones with ? & or spaces)

Download videos at best available quality with yt-dlp.

Two easy ways to provide links:
  1. Run with no URL/file arguments. You'll be prompted to paste URLs,
     one per line (no quotes, one or many). Press Ctrl-D when done.
  2. Pass one or more .txt files holding one URL per line.
In pasted input and files, blank lines and lines beginning with '#', ';'
or ']' are ignored. (You can still pass URLs as arguments, but ones with
?, & or spaces must be quoted, since the shell parses them first.)

If yt-dlp can't extract a page directly, get_video scrapes the page HTML for
the first .m3u8/.mp4 stream and retries with that.

Performance (on by default; disable all with --safe):
  - downloads run in parallel               (--parallel)
  - aria2c multi-connection downloader       (used if installed)
  - browser cookies extracted once, reused   (whole batch)
Failed URLs are retried automatically, then written to <dir>/failed.txt.

Options:
  -d, --dir DIR        Output directory (default: ./downloads)
  -c, --cookies NAME   Cookies from browser NAME (chrome, firefox, ...).
                       Default: chrome. Use 'none' to disable.
  -a, --archive FILE   Download-archive for skip/resume (default: <dir>/.archive)
  -p, --parallel N     Videos downloaded at once (default: 4, or 1 with --safe)
  -j, --jobs N         Concurrent fragments per video (default: 8, or 4 with --safe)
      --retries N      Retry a failed URL N times (default: 3)
      --retry-wait S   Seconds between retries (default: 30)
      --safe           Disable parallelism, aria2c and cookie caching
  -h, --help           Show this help

Override the binary with YTDLP_BIN, e.g.
  YTDLP_BIN=/Users/zach/opt/miniconda3/bin/yt-dlp $PROG
EOF
}

die() {
    printf '%s: %s\n' "$PROG" "$*" >&2
    exit 1
}

dir="./downloads"
cookies="chrome"
archive=""
jobs=""
parallel=""
retries=3
retry_wait=30
fast=1
urls=()

while (($#)); do
    case $1 in
    -d | --dir)
        dir=${2:?--dir needs a value}
        shift 2
        ;;
    -c | --cookies)
        cookies=${2:?--cookies needs a value}
        shift 2
        ;;
    -a | --archive)
        archive=${2:?--archive needs a value}
        shift 2
        ;;
    -p | --parallel)
        parallel=${2:?--parallel needs a value}
        shift 2
        ;;
    -j | --jobs)
        jobs=${2:?--jobs needs a value}
        shift 2
        ;;
    --retries)
        retries=${2:?--retries needs a value}
        shift 2
        ;;
    --retry-wait)
        retry_wait=${2:?--retry-wait needs a value}
        shift 2
        ;;
    --safe)
        fast=0
        shift
        ;;
    -h | --help)
        usage
        exit 0
        ;;
    --)
        shift
        break
        ;;
    -*) die "unknown option: $1" ;;
    *) break ;;
    esac
done

# Effective defaults depend on fast/safe mode unless set explicitly.
[[ -n $parallel ]] || parallel=$((fast ? 4 : 1))
[[ -n $jobs ]] || jobs=$((fast ? 8 : 4))

parse_lines() { # read URLs (one per line) from stdin into urls[]
    local line
    while IFS= read -r line || [[ -n $line ]]; do
        line="${line#"${line%%[![:space:]]*}"}" # ltrim
        line="${line%"${line##*[![:space:]]}"}" # rtrim
        [[ -z $line || $line == [\#\;\]]* ]] && continue
        urls+=("$line")
    done
}

collect() {
    local arg=$1
    if [[ -f $arg ]]; then
        parse_lines <"$arg"
    else
        urls+=("$arg")
    fi
}

if (($#)); then
    for arg in "$@"; do collect "$arg"; done
else
    # No URL/file args: paste mode.
    if [[ -t 0 ]]; then
        printf '\nPaste video URLs below — one per line, no quotes needed.\n' >&2
        printf '(One or many. Blank lines and #/;/] comments are ignored.)\n' >&2
        printf 'Press Ctrl-D on an empty line when done.\n\n' >&2
    fi
    parse_lines
    [[ -t 0 ]] && printf 'Got %d URL(s).\n' "${#urls[@]}" >&2
fi

((${#urls[@]})) || {
    usage
    die "no URLs provided"
}
command -v "$ytdlp" >/dev/null 2>&1 || die "'$ytdlp' not found in PATH"

mkdir -p "$dir"
[[ -n $archive ]] || archive="$dir/.archive"

total=${#urls[@]}
out_default="$dir/%(title)s [%(id)s].%(ext)s"

ytdlp_args=(
    -S "res,fps,proto:m3u8"
    -f "bv*+ba/b"
    --embed-thumbnail --embed-metadata --no-mtime
    --no-overwrites
    --ignore-errors
    --fragment-retries 15
    -N "$jobs"
)

# --- cookies (D): extract once and reuse across the batch in fast mode ---
cookiejar=""
if [[ $cookies != none ]]; then
    if ((fast && total > 1)) && cookiejar=$(mktemp -t get_video_cookies 2>/dev/null); then
        chmod 600 "$cookiejar"
        if "$ytdlp" --cookies-from-browser "$cookies" --cookies "$cookiejar" \
            --skip-download --ignore-errors --no-warnings -- "${urls[0]}" >/dev/null 2>&1 &&
            [[ -s $cookiejar ]]; then
            ytdlp_args+=(--cookies "$cookiejar")
        else
            rm -f "$cookiejar"
            cookiejar=""
            ytdlp_args+=(--cookies-from-browser "$cookies")
        fi
    else
        cookiejar=""
        ytdlp_args+=(--cookies-from-browser "$cookies")
    fi
fi

# --- downloader (C): aria2c multi-connection, fast mode only, if present ---
downloader=""
downloader_args=""
if ((fast)) && command -v aria2c >/dev/null 2>&1; then
    downloader="aria2c"
    downloader_args="aria2c:-x8 -s8 -k1M --max-tries=3 --retry-wait=30 --console-log-level=warn --summary-interval=0"
fi

# --- working dirs / cleanup ---
failfile=$(mktemp -t get_video_failed)
logdir=""
((parallel > 1)) && logdir=$(mktemp -d -t get_video_logs)
cleanup() {
    [[ -n ${cookiejar:-} ]] && rm -f "$cookiejar" || true
    [[ -n ${logdir:-} ]] && rm -rf "$logdir" || true
    [[ -n ${failfile:-} ]] && rm -f "$failfile" || true
}
trap cleanup EXIT

exec 9>&2 # status channel: survives per-job log redirection
status() { printf '%s\n' "$*" >&9; }

# Fallback resolver: scrape page HTML for the first direct .m3u8/.mp4 stream
# and a clean title. Prints "<stream-url>\t<title>", non-zero if none found.
ua="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15) AppleWebKit/537.36"
resolve_page() {
    local page=$1 html stream title
    html=$(curl -fsSL -A "$ua" "$page") || return 1
    stream=$(grep -oE 'https?://[^"'\''[:space:]]+\.(m3u8|mp4)' <<<"$html" | head -1) || true
    [[ -n $stream ]] || return 1
    title=$(grep -oE '<title>[^<]*</title>' <<<"$html" | head -1) || true
    title=${title#<title>}
    title=${title%</title>}
    title=${title%%' | '*} # strip trailing " | SiteName"
    title=${title//&amp;/&}
    title=${title//&#39;/\'}
    title=${title//&quot;/\"}
    title=${title//\//-} # filesystem-safe
    title=${title//%/%%} # protect yt-dlp output template
    printf '%s\t%s\n' "$stream" "$title"
}

# Run yt-dlp once. native=1 forces the built-in downloader (most compatible).
try_dl() {
    local out=$1 referer=$2 target=$3 native=$4
    local args=("${ytdlp_args[@]}" -o "$out")
    if [[ -n $referer ]]; then
        # Fallback (scraped stream): generic ids collide — every stream is
        # named ts.m3u8 -> id "ts" — so the shared archive would skip every
        # video after the first. Dedupe by the unique title filename
        # (--no-overwrites) instead, and no archive here.
        args+=(--add-header "Referer:$referer")
    else
        # Direct download: real extractor ids, so the archive is meaningful.
        args+=(--download-archive "$archive")
    fi
    if ((native == 0)) && [[ -n $downloader ]]; then
        args+=(--downloader "$downloader" --downloader-args "$downloader_args")
    fi
    "$ytdlp" "${args[@]}" -- "$target"
}

# Download one URL: try direct, then page-scrape fallback; retry on failure.
# Final attempt drops aria2c for the native downloader. Records failures.
download_one() {
    local url=$1 idx=$2 attempt last resolved stream title out
    local log="${logdir:-}/$idx.log"
    status "[$idx/$total] >> $url"
    for ((attempt = 1; attempt <= retries + 1; attempt++)); do
        if ((attempt == retries + 1)); then last=1; else last=0; fi

        if try_dl "$out_default" "" "$url" "$last"; then
            status "[$idx/$total] OK"
            return 0
        fi

        if resolved=$(resolve_page "$url"); then
            stream=${resolved%%$'\t'*}
            title=${resolved#*$'\t'}
            if [[ -n $title ]]; then out="$dir/$title.%(ext)s"; else out="$out_default"; fi
            printf '  -> scraped stream: %s\n' "$stream"
            if try_dl "$out" "$url" "$stream" "$last"; then
                status "[$idx/$total] OK${title:+ ($title)}"
                return 0
            fi
        fi

        if ((attempt <= retries)); then
            printf '  -> attempt %d failed; retrying in %ss\n' "$attempt" "$retry_wait"
            status "[$idx/$total] retry $attempt/$retries in ${retry_wait}s"
            sleep "$retry_wait"
        fi
    done

    printf '%s\n' "$url" >>"$failfile"
    status "[$idx/$total] FAILED: $url"
    if ((parallel > 1)) && [[ -f $log ]]; then
        status "      last log lines:"
        tail -n 12 "$log" >&9 2>/dev/null || true
    fi
    return 1
}

# Block until fewer than $parallel background jobs are running.
pids=()
wait_slot() {
    local p alive
    while :; do
        alive=0
        for p in ${pids[@]+"${pids[@]}"}; do
            if kill -0 "$p" 2>/dev/null; then alive=$((alive + 1)); fi
        done
        if ((alive < parallel)); then break; fi
        sleep 0.3
    done
}

idx=0
for url in "${urls[@]}"; do
    idx=$((idx + 1))
    if ((parallel > 1)); then
        wait_slot
        download_one "$url" "$idx" >"$logdir/$idx.log" 2>&1 &
        pids+=("$!")
    else
        download_one "$url" "$idx" || true
    fi
done
((parallel > 1)) && { wait || true; }

failed=()
if [[ -s $failfile ]]; then
    while IFS= read -r line; do failed+=("$line"); done <"$failfile"
fi

printf '\n========================================\n'
printf 'Done: %d total, %d ok, %d failed\n' \
    "$total" "$((total - ${#failed[@]}))" "${#failed[@]}"

if ((${#failed[@]})); then
    failpersist="$dir/failed.txt"
    printf '%s\n' "${failed[@]}" >"$failpersist"
    printf '\nNeeds attention (saved to %s):\n' "$failpersist"
    printf '  %s\n' "${failed[@]}"
    printf '\nRetry just these with:\n  %s -d %q %q\n' "$PROG" "$dir" "$failpersist"
    exit 1
fi
