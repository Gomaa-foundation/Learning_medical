#!/usr/bin/env python3
import os
import subprocess
import platform
from datetime import datetime

def get_system_summary():
    """Gathers basic system identifiers."""
    print(f"--- System Check | {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} ---")
    print(f"Hostname:  {platform.node()}")
    print(f"OS/Kernel: {platform.system()} {platform.release()}")
    print(f"Architecture: {platform.machine()}")
    print("-" * 40)

def get_disk_status():
    """Checks disk usage using the system 'df' command."""
    print("Checking Disk Integrity...")
    output = subprocess.check_output(["df", "-h", "/"]).decode("utf-8")
    print(output)
    print("-" * 40)

def check_services():
    """Checks if critical system services are active."""
    print("Checking Critical Services...")
    # List of services to check
    services = ["systemd-journald", "dbus", "network-manager"]
    
    for srv in services:
        # systemctl is-active returns 0 if running, non-zero if not
        # We use 'run' instead of 'check_output' because we only care about the return code
        result = subprocess.run(["systemctl", "is-active", srv], capture_output=True, text=True)
        status = result.stdout.strip()
        
        if status == "active":
            print(f"[OK] {srv} is running.")
        else:
            print(f"[!!] WARNING: {srv} is {status}!")
    print("-" * 40)

def main():
    try:
        get_system_summary()
        get_disk_status()
        check_services()
    except Exception as e:
        print(f"CRITICAL ERROR during audit: {e}")

if __name__ == "__main__":
    main()
