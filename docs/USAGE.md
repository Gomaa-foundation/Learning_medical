# Usage & Workflow Guide: Study System v0.1.0

This guide explains how to use the Study System to master new subjects and track your career progress.

## 1. The Study Cycle

The system works in a simple four-step loop:

1. **Orchestrate**: Put new files in `input-library/` and use `/orchestrate` to organize them.
2. **Summarize**: Use `/summarize <name>` to create easy-to-read Fact Sheets in your `knowledge-base/`.
3. **Learn**: Use `/learn <name>` to start a tutoring session. Antigravity will explain concepts and test your understanding.
4. **Review**: Use `/review` daily. The system uses a smart schedule to test you on things you are about to forget.

---

## 2. Your Daily Routine

A "Perfect" study day looks like this:

1. **Check Status**: Run `./study.py status` to see what is due for review and your current career day.
2. **Review**: Use the `/review` command to clear your "DUE NOW" items.
3. **New Learning**: Use `/learn` on a new chapter or topic from your `study-plans/`.
4. **Sync**: Run `./study.py sync` to save all your progress to the Git Atlas.

---

## 3. Command Reference

### 🛠️ Organization Tools
| Command | Purpose | When to use |
|---|---|---|
| `/orchestrate` | Organizes your library. | When you add new PDFs or notes. |
| `/extract <file>` | Cleans up a raw document. | For messy text or large files. |
| `/summarize <name>` | Creates a Fact Sheet. | When you want a clear summary to study from. |

### 🧠 Learning Tools
| Command | Purpose | When to use |
|---|---|---|
| `/learn <topic>` | Guided study session. | When mastering a specific subject. |
| `/review` | Smart review session. | Every day to keep knowledge fresh. |
| `/find-related` | Finds connections. | When you're stuck and need a simpler explanation. |

### 📡 Intelligence Tools
| Command | Purpose | When to use |
|---|---|---|
| `/intel` | Daily news summary. | To keep up with your field of interest. |
| `/catchup` | Multi-day lookback. | After a break or weekend. |

---

## 💡 4. Pro Tips

- **Use the Dashboard**: Always start your day with `./study.py status`. It tells you exactly what needs your attention.
- **Trust the Assistant**: If a file is messy or the formatting looks wrong, just tell Antigravity: *"Fix the formatting in this chapter."* It will handle the details for you.
- **Stay Consistent**: The "Current Day" counter in your career dashboard is a great way to stay motivated. Try to keep your streak alive!

---

**Navigation**
[⬅️ Previous: Installation Guide](INSTALL.md) | [🏠 Home](../README.md) | [Next: Research Guide ➡️](RESEARCHER.md)
