#!/usr/bin/env python3
import time
import os
import random

def clear():
    os.system('clear')

def animate_text(text, delay=0.01):
    for char in text:
        print(char, end='', flush=True)
        time.sleep(delay)
    print()

def main():
    clear()
    animate_text("============================================================")
    animate_text("     ANTIGRAVITY ROLE DISCOVERY PROTOCOL | CAREER OS        ")
    animate_text("============================================================")
    animate_text("[SYSTEM] Initializing Competency Audit...")
    time.sleep(0.5)
    animate_text("[SYSTEM] Scanning Causal Knowledge Documents (knowledge-base)...")
    time.sleep(1)
    
    print("\n--- Diagnostic: Psychological Friction ---")
    animate_text("You are operating without a formal CS degree. The standard path is closed.")
    animate_text("We will now map your Sovereign OS outputs to the optimal High-Status Remote Archetype.")
    print("\n")
    
    print("Which cognitive loop feels most natural to you? (Select 1, 2, or 3)")
    print("1) Systems & Pipelines: I want to automate everything. I like NixOS, bash, and ensuring servers never crash.")
    print("2) Logic & Core: I want to build the brain. I like C, Rust, memory management, and deep algorithmic logic.")
    print("3) AI & Orchestration: I want to command agents. I like Python, API integrations, and NLP modeling.")
    
    # In an agentic loop, the agent (me) can read the user's preference or just print this for the user.
    # Since I am executing this for the user, I will just print the output and stop so I can ask them in chat.

if __name__ == "__main__":
    main()
