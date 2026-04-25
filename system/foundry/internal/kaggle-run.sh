#!/usr/bin/env bash
# system/foundry/internal/kaggle-run.sh
# Core Extraction Engine (v25.2-IRONHAND)
# Instrumented with 5-minute periodic notifications and Stateful Resumption.

WORKSPACE_ROOT="$(readlink -f "$(dirname "$0")/../../..")"
if command -v kaggle &>/dev/null; then
    VENV_KAGGLE="kaggle"
else
    VENV_KAGGLE="$WORKSPACE_ROOT/.venv/bin/kaggle"
fi

update_job_status() {
    local slug="$1"; local key="$2"; local val="$3"
    local d="$DOMAIN"
    [[ -z "$d" ]] && d="intelligence_engineering" # Deep fallback
    local study-plans_path="$WORKSPACE_ROOT/study-plans/${d}.study-plans"
    python3 "$WORKSPACE_ROOT/system/foundry/internal/orchestrator_utils.py" update "$study-plans_path" "$slug" "$key" "$val"
}

notify() {
    local level="$1"; local title="$2"; local msg="$3"
    bash "$WORKSPACE_ROOT/scripts/notify-desktop.sh" "$level" "$title" "$msg" || true
}

poll_dataset() {
    local slug="$1"
    local max_attempts=60; local attempt=0
    echo -n "  ⏳ Waiting for Dataset indexing..."
    while [[ $attempt -lt $max_attempts ]]; do
        local out
        out=$($VENV_KAGGLE datasets status "$slug" 2>&1 || true)
        if echo "$out" | grep -qi "ready"; then
            echo " Ready."
            return 0
        fi
        echo -n "."; sleep 15
        attempt=$((attempt + 1))
    done
    echo " [ERROR] Dataset indexing timed out."
    return 1
}

poll_kernel() {
    local slug="$1"
    local elapsed=0
    echo -n "  🧬 Monitoring MinerU GPU Extraction..."
    while true; do
        local status; status=$($VENV_KAGGLE kernels status "$slug" 2>&1 || echo "error")
        if echo "$status" | grep -qi "complete"; then break; fi
        if echo "$status" | grep -qiE "error|failed"; then 
            echo -e "\n❌ [KAGGLE ERROR] Kernel failed: $status"
            update_job_status "$BOOK_SLUG" "status" "KAGGLE_FAILED"
            exit 1
        fi
        echo -n "."; sleep 60
        elapsed=$((elapsed + 60))
        if (( elapsed % 300 == 0 )); then
            notify "normal" "⏳ Kaggle Extraction Active" "Still processing... ($((elapsed / 60)) min elapsed): $BOOK_SLUG"
        fi
    done
    echo " Success."
}

main() {
    local BOOK_SLUG=""; local DOMAIN=""; local K_USER="adriancoleian"; local DIRECT_PDF_PATH=""
    while [[ $# -gt 0 ]]; do
        case $1 in
            --book) BOOK_SLUG="$2"; shift 2 ;;
            --domain) DOMAIN="$2"; shift 2 ;;
            --user) K_USER="$2"; shift 2 ;;
            --pdf) DIRECT_PDF_PATH="$2"; shift 2 ;;
            *) echo "Unknown: $1"; exit 1 ;;
        esac
    done

    # 1. Credential Guard
    if [[ "$K_USER" == "chadlite" ]]; then export KAGGLE_CONFIG_DIR="$HOME/.kaggle-friend"; else export KAGGLE_CONFIG_DIR="$HOME/.kaggle"; fi
    KAGGLE_USER=$($VENV_KAGGLE config view | grep -i "username" | sed 's/.*username: //g' | tr -d ' ' || echo "")
    [[ -z "$KAGGLE_USER" ]] && { notify "critical" "Kaggle Auth Error" "Credentials missing or invalid."; exit 1; }
    
    # 0. EARLY LOCK: Prevent re-entry race immediately (v23.2-DESPAM)
    update_job_status "$BOOK_SLUG" "status" "SYNCING"
    
    notify "normal" "🚀 Starting Extraction" "$BOOK_SLUG on $KAGGLE_USER"

    # Start Heartbeat
    MAIN_PID=$$
    (
        local study-plans_path="$WORKSPACE_ROOT/study-plans/${DOMAIN}.study-plans"
        while kill -0 $MAIN_PID 2>/dev/null; do
            sleep 60
            python3 "$WORKSPACE_ROOT/system/foundry/internal/orchestrator_utils.py" heartbeat "$study-plans_path" "$BOOK_SLUG" 2>/dev/null || true
        done
    ) &
    HEARTBEAT_PID=$!
    trap 'kill $HEARTBEAT_PID 2>/dev/null || true' EXIT

    # 1.5 Stateful Cloud Resumption Check
    local existing_kernel
    existing_kernel=$(python3 -c "import yaml; print(yaml.safe_load(open('$WORKSPACE_ROOT/study-plans/${DOMAIN}.study-plans')).get('books', {}).get('$BOOK_SLUG', {}).get('kernel_id', ''))" 2>/dev/null || echo "")
    local existing_dataset
    existing_dataset=$(python3 -c "import yaml; print(yaml.safe_load(open('$WORKSPACE_ROOT/study-plans/${DOMAIN}.study-plans')).get('books', {}).get('$BOOK_SLUG', {}).get('dataset_id', ''))" 2>/dev/null || echo "")
    local resume_mode=0

    if [[ -n "$existing_kernel" && -n "$existing_dataset" ]]; then
        echo "  🔍 Checking cloud status for existing kernel: $existing_kernel"
        K_STATUS_RAW=$($VENV_KAGGLE kernels status "$existing_kernel" 2>&1 || echo "status \"MISSING\"")
        
        # Only resume if kernel is in a healthy/active state
        if [[ "$K_STATUS_RAW" == *"running"* || "$K_STATUS_RAW" == *"queued"* || "$K_STATUS_RAW" == *"complete"* ]]; then
            echo "♻️ [RESUME] Active cloud session found ($K_STATUS_RAW)! Re-attaching..."
            notify "normal" "♻️ Cloud Resume" "Re-attaching to $existing_kernel"
            KERNEL_SLUG="${existing_kernel#*/}"
            DATASET_SLUG="${existing_dataset#*/}"
            resume_mode=1
        else
            echo "⚠️ [CLEAN-START] Previous session $existing_kernel is dead or error ($K_STATUS_RAW). Starting fresh."
        fi
    fi

    if [[ $resume_mode -eq 0 ]]; then
        # 2. Atomic Sync (Fresh Launch)
        local PDF_PATH="$DIRECT_PDF_PATH"
        [[ ! -f "$PDF_PATH" ]] && { update_job_status "$BOOK_SLUG" "status" "MISSING_PDF"; exit 1; }
        
        local ATOMIC_SUFFIX=$(date +%s%N | cut -c11-15)
        local DATASET_SLUG="v252-$(echo "${BOOK_SLUG}" | cut -c1-25 | tr -cd '[:alnum:]-')-d-${ATOMIC_SUFFIX}"
        local KERNEL_SLUG="v252-$(echo "${BOOK_SLUG}" | cut -c1-25 | tr -cd '[:alnum:]-')-k-${ATOMIC_SUFFIX}"
        
        # Save IDs for future resumption
        update_job_status "$BOOK_SLUG" "kernel_id" "$KAGGLE_USER/$KERNEL_SLUG"
        update_job_status "$BOOK_SLUG" "dataset_id" "$KAGGLE_USER/$DATASET_SLUG"

        TMP_DIR=$(mktemp -d); trap 'rm -rf "$TMP_DIR"' EXIT

        echo "[STEP 1/4] Syncing PDF to Atomic Dataset: $DATASET_SLUG..."
        mkdir -p "$TMP_DIR/dataset"
        cp "$PDF_PATH" "$TMP_DIR/dataset/full-book.pdf"
        
        cat <<EOF > "$TMP_DIR/dataset/dataset-metadata.json"
{
  "title": "$DATASET_SLUG",
  "id": "$KAGGLE_USER/$DATASET_SLUG",
  "licenses": [{"name": "CC0-1.0"}]
}
EOF
        $VENV_KAGGLE datasets create -p "$TMP_DIR/dataset" --dir-mode zip -q
        poll_dataset "$KAGGLE_USER/$DATASET_SLUG"

        # 3. NATIVE MinerU CLI Trigger (v25.2-IRONHAND)
        echo "[STEP 2/4] Triggering MinerU 3.0+ CLI (RIGOROUS)..."
        mkdir -p "$TMP_DIR/kernel"
        cat <<EOF > "$TMP_DIR/kernel/kernel-metadata.json"
{
  "id": "$KAGGLE_USER/$KERNEL_SLUG",
  "title": "$KERNEL_SLUG",
  "code_file": "script.py",
  "language": "python",
  "kernel_type": "script",
  "is_private": "true",
  "enable_gpu": "true",
  "enable_internet": "true",
  "dataset_sources": ["$KAGGLE_USER/$DATASET_SLUG"]
}
EOF

        cat <<'EOF' > "$TMP_DIR/kernel/script.py"
import os, subprocess, sys, shutil
from pathlib import Path

def run_command(cmd, timeout=1800):
    print(f"🛠️  Running: {' '.join(cmd)}")
    try:
        subprocess.run(cmd, check=True, timeout=timeout)
    except Exception as e:
        print(f"❌ COMMAND FAILED: {e}")
        # Crash dump for remote debugging
        print("\n📂 [DEBUG] Directory Listing:")
        os.system("ls -R /kaggle/working")
        raise e

try:
    print("📦 Pre-flight Setup (Stable Mode)...")
    # Install mineru without breaking the base environment's torch
    run_command(["pip", "install", "mineru[pipeline]", "--no-deps", "-q"])
    # Ensure dependencies are present but dont force-reinstall torch
    run_command(["pip", "install", "magic-pdf[full]", "peft", "transformers", "-q"])
    
    pdf = next(Path("/kaggle/input").rglob("full-book.pdf"))
    out = Path("/kaggle/working/output")
    out.mkdir(parents=True, exist_ok=True)
    
    print(f"🧬 Extraction Start: {pdf}")
    # Increased timeout and strict backend
    run_command(["mineru", "-p", str(pdf), "-o", str(out), "--method", "txt", "--backend", "pipeline"])
    
    # Fuzzy sensing: Find any .md file produced (MinerU 3.0+ naming varies)
    md_files = list(out.rglob("*.md"))
    if not md_files:
        raise FileNotFoundError("❌ No markdown files found in output directory!")
    
    md_res = md_files[0]
    img_dir = md_res.parent / "images"
    print(f"✅ Found Markdown: {md_res}")
    
    shutil.copy(md_res, "/kaggle/working/full-book.md")
    if img_dir.exists():
        shutil.copytree(img_dir, "/kaggle/working/images", dirs_exist_ok=True)
        os.system("tar -czf /kaggle/working/full-book-result.tar.gz -C /kaggle/working full-book.md images")
    else:
        os.system("tar -czf /kaggle/working/full-book-result.tar.gz -C /kaggle/working full-book.md")
        
    print("🏁 Kernel Complete (VERIFIED).")
except Exception as e:
    print(f"❌ IRONHAND CRITICAL ERROR: {e}")
    os.system("ls -R /kaggle/working")
    sys.exit(1)
EOF
        # [STEP 2.1/4] Triggering NATIVE GPU Execution (with propagation retries)
        local push_attempt=1
        while [[ $push_attempt -le 3 ]]; do
            echo "🚀 [LAUNCH] Pushing kernel... (Attempt $push_attempt/3)"
            local push_out
            push_out=$($VENV_KAGGLE kernels push -p "$TMP_DIR/kernel" 2>&1 || true)
            echo "$push_out"
            
            if echo "$push_out" | grep -qi "successfully pushed"; then
                update_job_status "$BOOK_SLUG" "status" "DISPATCHED"
                notify "normal" "Book Dispatched to Kaggle" "$BOOK_SLUG"
                break
            elif echo "$push_out" | grep -qiE "quota|exhausted|403 - Forbidden"; then
                echo "❌ [QUOTA] GPU Quota exhausted for $KAGGLE_USER."
                update_job_status "$BOOK_SLUG" "status" "QUOTA_EXHAUSTED"
                notify "critical" "Kaggle Quota Exhausted" "Account: $KAGGLE_USER"
                exit 42
            else
                echo "⚠️ [PROPAGATION] Kernel push failed. Dataset may not be ready. Retrying in 60s..."
                sleep 60
                push_attempt=$((push_attempt + 1))
            fi
        done
        [[ $push_attempt -gt 3 ]] && { echo "❌ [ERROR] Kernel dispatch failed after 3 attempts."; exit 1; }
    fi

    echo "[STEP 3/4] Pulling Verified Results from Cloud..."
    update_job_status "$BOOK_SLUG" "status" "DISPATCHED"
    poll_kernel "$KAGGLE_USER/$KERNEL_SLUG"

    BOOK_DIR="$WORKSPACE_ROOT/input-library/$DOMAIN/$BOOK_SLUG"
    mkdir -p "$BOOK_DIR"
    $VENV_KAGGLE kernels output "$KAGGLE_USER/$KERNEL_SLUG" -p "$BOOK_DIR"
    
    if [[ -f "$BOOK_DIR/full-book-result.tar.gz" ]]; then
        echo "📂 Extracting Result Package..."
        tar -xzf "$BOOK_DIR/full-book-result.tar.gz" -C "$BOOK_DIR"
        rm -f "$BOOK_DIR/full-book-result.tar.gz"
        update_job_status "$BOOK_SLUG" "status" "INGESTED"
        notify "normal" "✅ Extraction Success!" "$BOOK_SLUG"
    else
        echo "❌ [ERROR] Result package not found."
        update_job_status "$BOOK_SLUG" "status" "DOWNLOAD_FAILED"
        exit 1
    fi
    $VENV_KAGGLE datasets delete -y "$KAGGLE_USER/$DATASET_SLUG" || true
}

main "$@"
