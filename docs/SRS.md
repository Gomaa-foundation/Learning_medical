# Anki Flashcards: Professional Mastery

This document explains how to use the automated flashcard system to master information quickly and efficiently.

## 1. Automated Generation

The Study System automatically identifies important facts and rules during your study sessions and prepares them for Anki.

- **Storage**: Generated cards are stored in `srs/german-sovereign.csv`.
- **Logic**: The system focuses on **Logic Anchors**—rules and structures that help you build new sentences, rather than just memorizing lists of words.

---

## 2. Professional Styling (Dark Mode)

To make your study sessions as pleasant as possible, use this clean, professional CSS in your Anki **Card Styling**.

### CSS Template
```css
.card {
  font-family: "Inter", "Roboto", "Segoe UI", sans-serif;
  font-size: 22px;
  text-align: center;
  color: #e0e0e0;
  background-color: #121212;
  line-height: 1.6;
  padding: 2em;
}

/* Question Styling */
b, strong {
  color: #03dac6; /* Teal for emphasis */
}

/* Cloze Deletion Styling */
.cloze {
  font-weight: bold;
  color: #bb86fc; /* Soft Purple for logic anchors */
}

/* Tags Styling */
.tags {
  font-size: 14px;
  color: #555;
  margin-top: 20px;
  font-style: italic;
}
```

---

## 3. How to Import

1. **Locate the File**: Open `srs/german-sovereign.csv`.
2. **Open Anki**: Click **Import File**.
3. **Select File**: Choose the `.csv` file.
4. **Settings**:
   - **Type**: Select "Basic" or "Cloze".
   - **Fields**: Map the columns to Front, Back, and Tags.
   - **Allow HTML**: Ensure this is checked.
5. **Import**: Your study material is now synced to your mobile device or computer.

---

## 💡 Mastery Tip

If a card takes more than **3 seconds** to answer, it is too complex. Break it down into smaller pieces. The goal is to make your knowledge as fast and automatic as a motor skill.

---

**Navigation**
[⬅️ Previous: User Manual](../docs/USER_MANUAL.md) | [🏠 Home](../README.md)
