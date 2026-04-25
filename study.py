#!/usr/bin/env python3
import sys
import os
import argparse
import json
import yaml
from datetime import date

# Add system dir to path
sys.path.append(os.path.join(os.path.dirname(os.path.abspath(__file__)), "system"))
from config import ROOT_DIR, MEDICAL_TRACKER_PATH, LOG_PATH, STUDY_PLANS_DIR
from models import TrackerSchema
from logger import StudyLogger

logger = StudyLogger(LOG_PATH)

def color_text(text, color_code):
    return f"\033[{color_code}m{text}\033[0m"

def print_header(title):
    print("\n" + "=" * 60)
    print(f"  {color_text(title, '1;34')}")
    print("=" * 60)

def cmd_status(args):
    """Show a high-level status of the Medical Mastery OS."""
    print_header("MEDICAL MASTERY OS v0.1.0 | CLINICAL DASHBOARD")
    
    # 1. Medical Progress
    if os.path.exists(MEDICAL_TRACKER_PATH):
        with open(MEDICAL_TRACKER_PATH, 'r') as f:
            data = yaml.safe_load(f)
            try:
                tracker = TrackerSchema(**data)
                print(f"\n[{color_text('CLINICAL MASTERY', '1;32')}]")
                today = date.today()
                for name, node in tracker.skills.items():
                    mastery_pct = node.p_mastery * 100
                    bar_len = int(mastery_pct / 5)
                    bar = "█" * bar_len + "░" * (20 - bar_len)
                    
                    # Calculate due status
                    status_text = ""
                    if node.last_review:
                        from datetime import timedelta
                        due_date = node.last_review + timedelta(days=int(node.stability))
                        if due_date <= today:
                            status_text = color_text(" [REVIEW DUE]", "1;31")
                        else:
                            status_text = f" (Due in {(due_date - today).days}d)"
                    
                    print(f"  {name:<25}: [{bar}] {mastery_pct:>5.1f}%{status_text}")
            except Exception as e:
                print(f"  {color_text('Error loading tracker:', '1;31')} {e}")
    else:
        print(f"\n[{color_text('INITIALIZATION REQUIRED', '1;33')}]")
        print("  No medical tracker found. Use /orchestrate to begin.")

    # 2. Board Prep Focus
    boards_path = os.path.join(STUDY_PLANS_DIR, "medical-boards")
    if os.path.exists(boards_path):
        print(f"\n[{color_text('BOARD PREP FOCUS', '1;35')}]")
        plans = [f for f in os.listdir(boards_path) if f.endswith('.md')]
        for plan in plans:
            print(f"  - {plan.replace('.md', '').upper()}")

    # 3. Recent Activity
    logs = logger.get_recent_logs(5)
    if logs:
        print(f"\n[{color_text('RECENT CLINICAL ACTIVITY', '1;36')}]")
        for log in reversed(logs):
            print(f"  {log['timestamp']} | {log['type']:<10} | {log['message']}")

    print("\n" + "=" * 60)

def cmd_sync(args):
    """Commit all progress to Git."""
    print_header("SYNCHRONIZING CLINICAL ATLAS")
    try:
        os.chdir(ROOT_DIR)
        os.system("git add .")
        os.system('git commit -m "Medical Mastery: Clinical Knowledge Sync"')
        logger.log_event("SYNC", "Synchronized state to Git Atlas")
        print(f"\n[{color_text('SUCCESS', '1;32')}] All clinical data committed.")
    except Exception as e:
        logger.log_event("ERROR", f"Git sync failed: {e}")
        print(f"\n[{color_text('FAILURE', '1;31')}] Git sync failed: {e}")

def cmd_doctor(args):
    """Check repository health and clinical file integrity."""
    print_header("MEDICAL OS DOCTOR | CLINICAL HEALTH CHECK")
    
    checks = {
        "Config": os.path.exists(os.path.join(ROOT_DIR, "system", "config.py")),
        "Knowledge Base": os.path.exists(os.path.join(ROOT_DIR, "knowledge-base")),
        "Progress Log": os.path.exists(LOG_PATH),
        "Board Plans": os.path.exists(os.path.join(ROOT_DIR, "study-plans", "medical-boards")),
    }
    
    all_ok = True
    for component, exists in checks.items():
        status = color_text("[OK]", "1;32") if exists else color_text("[MISSING]", "1;31")
        print(f"  {component:<20}: {status}")
        if not exists: all_ok = False
    
    if all_ok:
        print(f"\n[{color_text('SYSTEM HEALTHY', '1;32')}] All clinical components verified.")
        logger.log_event("DOCTOR", "Clinical health check passed")
    else:
        print(f"\n[{color_text('SYSTEM DEGRADED', '1;31')}] Some components are missing!")
        logger.log_event("DOCTOR", "Clinical health check found issues")

def main():
    parser = argparse.ArgumentParser(description="Medical Mastery OS CLI")
    subparsers = parser.add_subparsers(dest="command", help="Available commands")

    subparsers.add_parser("status", help="Show clinical dashboard")
    subparsers.add_parser("sync", help="Sync all progress to Git")
    subparsers.add_parser("doctor", help="Check system health")

    args = parser.parse_args()

    if args.command == "status":
        cmd_status(args)
    elif args.command == "sync":
        cmd_sync(args)
    elif args.command == "doctor":
        cmd_doctor(args)
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
