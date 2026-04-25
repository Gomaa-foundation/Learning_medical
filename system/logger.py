import os
import json
from datetime import datetime

class StudyLogger:
    def __init__(self, log_path):
        self.log_path = log_path

    def log_event(self, event_type, message):
        event = {
            "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "type": event_type,
            "message": message
        }
        
        logs = []
        if os.path.exists(self.log_path):
            with open(self.log_path, 'r') as f:
                try:
                    logs = json.load(f)
                except:
                    logs = []
        
        logs.append(event)
        # Keep only last 100 logs
        logs = logs[-100:]
        
        with open(self.log_path, 'w') as f:
            json.dump(logs, f, indent=2)

    def get_recent_logs(self, count=5):
        if not os.path.exists(self.log_path):
            return []
        with open(self.log_path, 'r') as f:
            try:
                logs = json.load(f)
                return logs[-count:]
            except:
                return []
