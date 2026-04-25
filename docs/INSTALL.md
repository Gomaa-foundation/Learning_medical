# Installation Guide: Study System v0.1.0

This guide explains how to set up your environment for the Study System. While it works on any Linux system, it is optimized for a declarative environment like NixOS.

## 1. Setup

The Study System is designed to be lightweight and portable.

1. **Antigravity**: This is the primary engine. Open this repository in Antigravity, and it will automatically read the `ANTIGRAVITY.md` file to understand how to assist you.
2. **Dependencies**: Ensure you have `git` and `ffmpeg` installed for processing media and managing history.
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install -y git ffmpeg python3-pip
   
   # Arch Linux
   sudo pacman -Syu git ffmpeg python-pip
   ```
3. **Python Libraries**: The system requires `PyYAML` and `Pydantic` for data validation.
   ```bash
   pip install pyyaml pydantic
   ```

## 2. External Tools

### Obsidian (Visualizing Knowledge)
1. Install [Obsidian](https://obsidian.md/).
2. Open the `Learning/` folder as a new vault.
3. Your knowledge will be organized inside `knowledge-base/` and `progress-tracker/`.

### Anki (Flashcards)
1. Install [Anki](https://apps.ankiweb.net/).
2. Install the `AnkiConnect` add-on (ID: 2055492159).
3. The Study System will automatically export cards to Anki during your study sessions.

---

## 3. First Steps

Once installed, run the health check to ensure everything is ready:
```bash
./study.py doctor
```

Then, use the `/orchestrate` command in the Antigravity chat to organize your library.

---

**Navigation**
[⬅️ Previous: Home](../README.md) | [🏠 Home](../README.md) | [Next: Usage & Workflow ➡️](USAGE.md)
