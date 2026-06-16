#!/usr/bin/env bash

LOCAL_DIR="${1:?Usage: $0 <local_dir> [remote_dir]}"
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
            if adb push "$filepath" "$REMOTE_DIR/$filename"; then
                pushed_files+=("$filepath")
                ((pushed++))
            else
                echo "[FAILED]    $filename"
                ((failed++))
            fi
        fi
    fi
done < <(find "$LOCAL_DIR" -maxdepth 1 -type f -print0)

echo ""
echo "Done. Pushed: $pushed | Skipped (existing): $skipped_existing | Skipped (gitignore): $skipped_gitignore | Failed: $failed"

# Collect all deletable files (pushed + skipped_existing)
deletable=("${pushed_files[@]}" "${skipped_existing_files[@]}")

if [[ ${#deletable[@]} -eq 0 ]]; then
    echo "No files to delete."
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
