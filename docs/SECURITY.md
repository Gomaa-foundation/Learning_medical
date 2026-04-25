# Security & Privacy: Study System

The Study System is your personal workspace. It contains your private notes, study progress, and goals. Protecting this information is important.

## 1. Data Privacy
- **Local First**: All your Fact Sheets and progress trackers are stored as plain text (YAML/JSON) on your own computer.
- **Git Backups**: The system is configured to back up your knowledge and progress to Git, but it ignores raw sources and large media files to keep your data private and the repository light.

## 2. Privacy with AI
- **Information Flow**: When you use AI commands, the text of the document you are studying is shared with the AI provider (like Google or Anthropic).
- **Privacy Mode**: If you require absolute privacy, you can use local AI models (via Ollama or similar tools). This ensures that your studies never leave your hardware.

## 3. Data Safety
- **Manual Cleaning**: Use the `/extract` command to remove any personal information from a document before you start summarizing it.
- **Secure Storage**: Since all your data is in the `Learning/` folder, you can use standard disk encryption tools to keep it safe if your computer is lost.

## 4. Secret Management
- **API Keys**: Never share your API keys or commit them to Git.
- **Environment Variables**: Use a `.env` file or your computer's environment variables to store your keys safely. The system's `.gitignore` is set up to protect these files automatically.

---
**Navigation**
[⬅️ Previous: Research Guide](../docs/RESEARCHER.md) | [🏠 Home](../README.md) | [Next: Unified CLI ➡️](../study.py)
