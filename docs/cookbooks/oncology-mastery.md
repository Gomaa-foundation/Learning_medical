# 🎗️ Cookbook: Mastering Your 1100-Page Oncology Book

This guide is designed specifically for your current project: mastering the 1100-page collection of research papers on tumors. Because this is a massive amount of information, we will use a **"Surgical Extraction"** approach.

---

## 📅 The 4-Step Oncology Workflow

### Step 1: Preparation (The "Scan")
Don't try to process all 1100 pages at once.
1.  **Divide the Book**: Identify the major sections (e.g., *Lung Tumors*, *Immunotherapy*, *Genetic Markers*).
2.  **Cloud Setup**: Ensure you have completed the [Kaggle GPU Setup](kaggle-setup.md) so I can process the large file.
3.  **Upload to Library**: Put the PDF (or specific chapters) into the `input-library/oncology-project/` folder.

### Step 2: Synthesis (The "Fact Sheet")
Use the system to turn dense research papers into high-yield notes.
1.  **Command**: Type `/summarize oncology-project` in the chat.
2.  **What I'll do**: I will extract the **PICO** (Patient, Intervention, Comparison, Outcome) data from every paper and create a clean "Clinical Fact Sheet" in your `knowledge-base/`.

### Step 3: Clinical Rounds (The "Deep Dive")
Instead of just reading, we will simulate a hospital round.
1.  **Command**: Type `/learn oncology-project` when you have 15 minutes.
2.  **What we'll do**: I will present you with a clinical vignette based on one of the tumor types you've just synthesized and ask you for the **Next Best Step in Management**.

### Step 4: Long-Term Retention (The "Vault")
Ensure you remember the genetic markers and treatment protocols months from now.
1.  **Command**: Type `/review` every morning for 5-10 minutes.
2.  **What it does**: I will test you on the most critical facts from the 1100-page book using Spaced Repetition.

---

## 💡 Tips for Massive Books
-   **Focus on the "Pearls"**: Don't worry about the raw data in the papers; focus on the *Clinical Implications* that I highlight in your Fact Sheets.
-   **Use the Dashboard**: Type `./study.py status` to see which sections of the 1100-page book you have mastered (Green) and which ones you need to revisit (Red).
-   **Ask Questions**: You can ask me anything about the papers, such as "What was the 5-year survival rate mentioned in the Smith et al. paper?"

---

**Navigation**
[📖 Back to Cookbooks](manual.md) | [🏠 Home](../../README.md)
