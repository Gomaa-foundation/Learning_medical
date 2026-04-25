# System Architecture: Study System v0.1.0

This document explains the internal structure of the Study System and how it processes information to help you learn.

## 1. The Core Engine

The Study System is built on the principle of **Automated Organization**. Instead of manually managing files, the system uses an AI Assistant (Antigravity) to handle the complex tasks of reading, cleaning, and summarizing documents.

### How Information Flows
1. **Input**: You put a raw PDF or note into the `input-library/`.
2. **Cleaning**: The `/extract` command removes headers, footers, and page numbers, creating clean text.
3. **Summarizing**: The `/summarize` command identifies the most important concepts and creates a "Fact Sheet" in your `knowledge-base/`.
4. **Tracking**: Every time you study, the system updates your mastery level in the `progress-tracker/`.

---

## 2. Storage & Organization

The system uses a simple, flat structure to keep your data organized:

- **`input-library/`**: Your raw, unprocessed materials.
- **`knowledge-base/`**: Your finalized, summarized knowledge.
- **`progress-tracker/`**: Data files that track what you know and what you need to review.
- **`study-plans/`**: Step-by-step guides for mastering specific domains (like German or Career).

---

## 3. The Validation Layer

To ensure your data is never lost or corrupted, the system includes several safety features:

- **Unified CLI (`study.py`)**: A single tool to check system health and view your progress.
- **Data Models**: The system uses professional data validation (Pydantic) to ensure your trackers are always structurally sound.
- **Health Checks**: The `./study.py doctor` command scans your entire repository for missing files or broken links.

---

## 4. Professional Versioning (Git)

The Study System is a professional tool. It uses Git to version your knowledge and progress:
- **Knowledge Assets**: Your Fact Sheets and progress trackers are backed up so you never lose your history.
- **Privacy**: Large media files and raw sources are ignored to keep the repository light and your private files safe.

---

## 5. Technical Foundations

For those interested in the deep research and cognitive science that powers the Study System, please refer to the documents in the [**`legacy-technical-docs/`**](../legacy-technical-docs/) folder.

---

**Navigation**
[⬅️ Previous: User Manual](USER_MANUAL.md) | [🏠 Home](../README.md) | [Next: Installation Guide](INSTALL.md)
