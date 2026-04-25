#!/usr/bin/env bash
# bin/internal/extract-book-local.sh
set -euo pipefail

notify() {
    local urgency="${1:-normal}"
    local summary="$2"
    local body="${3:-}"
    bash "$WORKSPACE_ROOT/scripts/notify-desktop.sh" --urgency="$urgency" --app-name="Learning OS" "$summary" "$body" 2>/dev/null || true
}

usage() {
    echo "Usage: $0 --book-pdf <path> --profile <yaml> --output <dir>"
    exit 1
}

main() {
    WORKSPACE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
    BOOK_PDF="" PROFILE="" OUTPUT_DIR=""
    while [[ "$#" -gt 0 ]]; do
        case $1 in
            -h|--help)   usage ;;
            --book-pdf)  BOOK_PDF="$2";   shift 2 ;;
            --profile)   PROFILE="$2";    shift 2 ;;
            --output)    OUTPUT_DIR="$2"; shift 2 ;;
            *) echo "Unknown argument: $1"; usage ;;
        esac
    done

    [[ -z "$BOOK_PDF" || -z "$PROFILE" || -z "$OUTPUT_DIR" ]] && usage

    mkdir -p "$OUTPUT_DIR"
    TEMP_DIR=$(mktemp -d)
    FULL_BOOK_MD="$TEMP_DIR/full-book.md"

    # Derive the persist path
    PERSIST_DIR="$(dirname "$OUTPUT_DIR")"
    PERSIST_FULL_BOOK="$PERSIST_DIR/full-book.md"

    cleanup() {
        EXIT_CODE=$?
        # Close MinerU lock if open
        if [[ "${LOCK_OPENED:-0}" -eq 1 ]]; then
            exec 200>&- 2>/dev/null || true
        fi
        if [[ $EXIT_CODE -eq 0 ]]; then
            rm -rf "$TEMP_DIR"
        else
            echo "[DEBUG] Preserving TEMP_DIR: $TEMP_DIR"
        fi
    }
    trap cleanup EXIT

    SLUG=$(basename "$PROFILE" -profile.yaml)

    echo "========================================================="
    echo "Book Extraction Pipeline: $SLUG"
    echo "Profile:   $PROFILE"
    echo "Output:    $OUTPUT_DIR"
    echo "========================================================="
    echo ""

    # ── Stage 1: Extraction ───────────────────────────────────────────────────────
    if [[ -f "$PERSIST_FULL_BOOK" ]]; then
        echo "Stage 1/4: [SKIP] Persisted full-book.md found."
        echo "           Using cached extraction from: $PERSIST_FULL_BOOK"
        cp "$PERSIST_FULL_BOOK" "$FULL_BOOK_MD"
    else
        echo "Stage 1/4: Running MinerU in 100-page progressive segments..."
        
        # CPU Safety Queue
        LOCKFILE="/tmp/mineru.lock"
        echo "[QUEUE] Requesting MinerU lock..."
        exec 200>"$LOCKFILE"
        flock 200
        LOCK_OPENED=1
        echo "[QUEUE] Lock acquired."
        notify low "🔒 $SLUG: MinerU lock acquired" "Starting chunked CPU extraction..."
        
        # Portable MinerU command resolution
        MINERU_CMD=$(command -v mineru || echo "/run/current-system/sw/bin/mineru")
        echo "[INFO] Using MinerU at: $MINERU_CMD"

        TOTAL_PAGES=$(python3 "$WORKSPACE_ROOT/system/foundry/internal/pdf-pages.py" "$BOOK_PDF")
        [[ "$TOTAL_PAGES" -eq 0 ]] && TOTAL_PAGES=2000

        CHUNK_SIZE=100
        MAX_RETRIES=3
        rm -f "$FULL_BOOK_MD"
        touch "$FULL_BOOK_MD"
        mkdir -p "$TEMP_DIR/output/images"

        for (( start=0; start < TOTAL_PAGES; start += CHUNK_SIZE )); do
            end=$(( start + CHUNK_SIZE - 1 ))
            REMAINING=$(( TOTAL_PAGES - (end + 1) ))
            if [[ $REMAINING -gt 0 && $REMAINING -lt 50 ]]; then
                end=$(( TOTAL_PAGES - 1 ))
            fi
            [[ $end -ge $TOTAL_PAGES ]] && end=$(( TOTAL_PAGES - 1 ))

            echo "--- [CHUNK] Pages $start to $end ---"
            notify low "📄 $SLUG: Extracting pages $start–$end" "Chunk in progress..."
            PART_OUT="$TEMP_DIR/part_$start"
            CHUNK_MARKER="$PART_OUT/DONE_MARKER"

            if [[ ! -f "$CHUNK_MARKER" ]]; then
                RETRY_COUNT=0
                SUCCESS=0
                until [[ $SUCCESS -eq 1 || $RETRY_COUNT -ge $MAX_RETRIES ]]; do
                    "$MINERU_CMD" -p "$BOOK_PDF" \
                           -o "$PART_OUT" \
                           -b pipeline -m txt -l en --device cpu \
                           -s "$start" -e "$end" && SUCCESS=1 || {
                        RETRY_COUNT=$((RETRY_COUNT + 1))
                        notify critical "⚠️ $SLUG: Chunk retry $RETRY_COUNT/$MAX_RETRIES" "Pages $start–$end. Waiting 30s."
                        echo "[ERROR] Retry $RETRY_COUNT/$MAX_RETRIES..."
                        sleep 30
                    }
                    # Terminate if MinerU succeeded but produced zero markdown (overshoot)
                    if [[ $SUCCESS -eq 1 ]] && ! find "$PART_OUT" -name "*.md" 2>/dev/null | grep -q "."; then
                        echo "[INFO] No more pages found at index $start. Terminating chunk loop."
                        touch "$CHUNK_MARKER"
                        break 2
                    fi
                done
                if [[ $SUCCESS -eq 1 ]]; then touch "$CHUNK_MARKER"; else exit 1; fi
            fi

            PART_MD=$(find "$PART_OUT" -name "*.md" 2>/dev/null | head -1)
            if [[ -z "$PART_MD" ]]; then
                echo "[INFO] No more pages found (overshoot or empty segment). Terminating chunk loop."
                break
            fi

            if [[ -n "$PART_MD" ]]; then
                cat "$PART_MD" >> "$FULL_BOOK_MD"
                echo -e "\n\n" >> "$FULL_BOOK_MD"
                PART_IMG_DIR=$(dirname "$PART_MD")/images
                if [ -d "$PART_IMG_DIR" ]; then
                    cp -rn "$PART_IMG_DIR"/* "$TEMP_DIR/output/images/" 2>/dev/null || true
                fi
            fi
            [[ $end -ge $(( TOTAL_PAGES - 1 )) ]] && break
        done

        echo "Persisting full-book.md to: $PERSIST_FULL_BOOK"
        cp "$FULL_BOOK_MD" "$PERSIST_FULL_BOOK"
        notify normal "📄 $SLUG: Extraction complete" "All chunks done. Splitting into chapters..."
    fi

    # ── Stage 2: Split ────────────────────────────────────────────────────────────
    echo ""
    echo "Stage 2/4: Splitting full markdown into chapters..."
    python3 "$WORKSPACE_ROOT/system/foundry/internal/split-chapters.py" \
        --input   "$FULL_BOOK_MD" \
        --output  "$OUTPUT_DIR" \
        --profile "$PROFILE" \
        --verbose
    notify low "✂️ $SLUG: Chapters split" "Sanitizing markdown..."

    # ── Stage 3: Sanitize ─────────────────────────────────────────────────────────
    SAN_DIR="$(dirname "$OUTPUT_DIR")/chapters-sanitized"
    READY_DIR="$(dirname "$OUTPUT_DIR")/chapters-ready"

    echo ""
    echo "Stage 3/4: Sanitizing markdown..."
    python3 "$WORKSPACE_ROOT/system/foundry/sanitize.py" \
        --input "$OUTPUT_DIR" \
        --output "$SAN_DIR"
    notify low "🧹 $SLUG: Sanitizing done" "Injecting metadata..."

    # ── Stage 4: Inject ───────────────────────────────────────────────────────────
    echo ""
    echo "Stage 4/4: Injecting metadata..."
    bash "$WORKSPACE_ROOT/system/foundry/inject-metadata.sh" \
        --profile "$PROFILE" \
        --chapters "$SAN_DIR" \
        --output "$READY_DIR"
    notify low "🏷️ $SLUG: Metadata injected" "Pipeline complete."

    echo ""
    echo "========================================================="
    echo "Pipeline complete for $SLUG!"
    echo "Final Files: $READY_DIR"
    echo "========================================================="
}

main "$@"

