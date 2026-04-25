import os

# Base Paths
ROOT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Knowledge Base & Tracker
KNOWLEDGE_BASE_DIR = os.path.join(ROOT_DIR, "knowledge-base")
PROGRESS_TRACKER_DIR = os.path.join(ROOT_DIR, "progress-tracker")
INPUT_LIBRARY_DIR = os.path.join(ROOT_DIR, "input-library")
STUDY_PLANS_DIR = os.path.join(ROOT_DIR, "study-plans")
STATE_DIR = os.path.join(ROOT_DIR, "state")
LOG_PATH = os.path.join(ROOT_DIR, "logs", "study_events.json")

# Medical Mastery Paths
MEDICAL_TRACKER_PATH = os.path.join(PROGRESS_TRACKER_DIR, "medical.yaml")
BOARDS_PLAN_PATH = os.path.join(STUDY_PLANS_DIR, "medical-boards", "step1.md")

# System Internals
SYSTEM_DIR = os.path.join(ROOT_DIR, "system")
COMMANDS_DIR = os.path.join(SYSTEM_DIR, "commands")
FOUNDRY_DIR = os.path.join(SYSTEM_DIR, "foundry")

def get_relative_path(absolute_path):
    """Convert an absolute path to one relative to ROOT_DIR."""
    return os.path.relpath(absolute_path, ROOT_DIR)

if __name__ == "__main__":
    print(f"Medical Mastery Root: {ROOT_DIR}")
