#!/usr/bin/env bash

USAGE="Usage: $0 [-r|--max-retries N] [-w|--retry-wait SECONDS] <local_dir> [remote_dir]"

MAX_RETRIES="${MAX_RETRIES:-3}"
RETRY_WAIT="${RETRY_WAIT:-30}"

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        -r|--max-retries) MAX_RETRIES="$2"; shift 2 ;;
        -w|--retry-wait)  RETRY_WAIT="$2"; shift 2 ;;
        -h|--help)        echo "$USAGE"; exit 0 ;;
        -*)               echo "Unknown option: $1" >&2; echo "$USAGE" >&2; exit 1 ;;
        *)                POSITIONAL+=("$1"); shift ;;
    esac
done
set -- "${POSITIONAL[@]}"

LOCAL_DIR="${1:?$USAGE}"
REMOTE_DIR="${2:-/sdcard/Movies}"
DRY_RUN="${DRY_RUN:-0}"

LOCAL_DIR="${LOCAL_DIR%/}"
REMOTE_DIR="${REMOTE_DIR%/}"

GITIGNORE_GLOBAL=$(git config --global core.excludesFile 2>/dev/null)
GITIGNORE_GLOBAL="${GITIGNORE_GLOBAL:-$HOME/.gitignore_global}"
GITIGNORE_GLOBAL="${GITIGNORE_GLOBAL/#\~/$HOME}"

if [[ ! -f "$GITIGNORE_GLOBAL" ]]; then
    echo "Warning: no global gitignore found at '$GITIGNORE_GLOBAL', proceeding without gitignore filtering."
    GITIGNORE_GLOBAL=""
fi

is_gitignored() {
    local filename
    filename=$(basename "$1")

    [[ -z "$GITIGNORE_GLOBAL" ]] && return 1

    while IFS= read -r pattern || [[ -n "$pattern" ]]; do
        [[ -z "$pattern" || "$pattern" == \#* ]] && continue
        pattern="${pattern%/}"
        [[ "$filename" == $pattern ]] && return 0
    done <"$GITIGNORE_GLOBAL"

    return 1
}

echo "Fetching existing files from device..."
existing=$(adb shell "find '$REMOTE_DIR' -type f -exec basename {} \;" 2>/dev/null)

[[ "$DRY_RUN" == "1" ]] && echo "[DRY RUN — no files will be pushed]"

pushed=0
skipped_existing=0
skipped_gitignore=0
failed=0

pushed_files=()
skipped_existing_files=()

while IFS= read -r -d '' filepath; do
    filename=$(basename "$filepath")

    if is_gitignored "$filepath"; then
        echo "[GITIGNORE] $filename"
        ((skipped_gitignore++))
    elif echo "$existing" | grep -qxF "$filename"; then
        echo "[SKIP]      $filename"
        skipped_existing_files+=("$filepath")
        ((skipped_existing++))
    else
        if [[ "$DRY_RUN" == "1" ]]; then
            echo "[DRY PUSH]  $filename"
            pushed_files+=("$filepath")
            ((pushed++))
        else
            echo "[PUSH]      $filename"
            attempt=0
            push_ok=0
            while :; do
                if adb push "$filepath" "$REMOTE_DIR/$filename"; then
                    push_ok=1
                    break
                fi
                ((attempt++))
                (( attempt > MAX_RETRIES )) && break
                echo "[RETRY]     $filename (retry $attempt/$MAX_RETRIES in ${RETRY_WAIT}s)"
                sleep "$RETRY_WAIT"
            done
            if (( push_ok )); then
                pushed_files+=("$filepath")
                ((pushed++))
            else
                echo "[FAILED]    $filename (gave up after $MAX_RETRIES retries)"
                ((failed++))
            fi
        fi
    fi
done < <(find "$LOCAL_DIR" -maxdepth 1 -type f -print0)

echo ""
echo "Done. Pushed: $pushed | Skipped (existing): $skipped_existing | Skipped (gitignore): $skipped_gitignore | Failed: $failed"

report_storage() {
    local storage size used avail pct
    storage=$(adb shell df -h /sdcard 2>/dev/null | awk '
        NR > 1 {
            for (i = 1; i <= NF; i++) if ($i ~ /%$/) {
                print $(i-3), $(i-2), $(i-1), $i
                exit
            }
        }')
    read -r size used avail pct <<<"$storage"
    echo ""
    if [[ -n "$pct" ]]; then
        echo "Quest storage: $used used of $size ($pct used, $avail free)"
    else
        echo "Quest storage: unable to read device storage info."
    fi
}

# Collect all deletable files (pushed + skipped_existing)
deletable=("${pushed_files[@]}" "${skipped_existing_files[@]}")

if [[ ${#deletable[@]} -eq 0 ]]; then
    echo "No files to delete."
    report_storage
    exit 0
fi

echo ""
echo "The following files were pushed or already existed on the device:"
for f in "${deletable[@]}"; do
    echo "  $f"
done

echo ""
read -r -p "Delete all of the above from local path? [y/N] " answer
if [[ "${answer,,}" == "y" ]]; then
    for f in "${deletable[@]}"; do
        rm "$f" && echo "Deleted: $f"
    done
    echo "Done."
else
    echo "No files deleted."
fi

report_storage
