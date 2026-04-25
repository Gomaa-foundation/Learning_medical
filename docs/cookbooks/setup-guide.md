# 🚀 Windows Setup Guide: Getting Started

Welcome! This guide will help you set up your Medical Mastery OS on your Windows computer. We've designed this to be as straightforward as possible.

---

## 1. Install Python (The Engine)
Python is the language that powers your Clinical Research Assistant.

1.  Open the **Microsoft Store** on your computer.
2.  Search for **"Python 3.12"** (or the latest version).
3.  Click **"Get"** or **"Install"**.
4.  **Important**: Once installed, open your Command Prompt (type `cmd` in the Start menu) and type `python --version`. If it shows a version number, you are good to go!

---

## 2. Install Git & GitHub (The Library Sync)
This allows you to sync your medical knowledge with the secure "Gomaa Foundation" cloud.

1.  **Download GitHub Desktop**: Visit [desktop.github.com](https://desktop.github.com/) and click **"Download for Windows"**.
2.  **Sign In**: Open the app and sign in with your GitHub account.
3.  **Clone the Repository**:
    -   Click on **"File"** > **"Clone Repository"**.
    -   Select **"URL"** and paste this: `https://github.com/Gomaa-foundation/Learning_medical.git`
    -   Choose where you want to save it on your computer and click **"Clone"**.

---

## 3. Install System Dependencies
Now we need to install the small tools that help the system run.

1.  In **GitHub Desktop**, click on **"Repository"** > **"Open in Command Prompt"**.
2.  In the black window that opens, type (or copy-paste) this command and press Enter:
    ```cmd
    pip install -r requirements.txt
    ```
3.  Wait for the progress bars to finish.

---

## 4. Final Verification
Let's make sure everything is working perfectly.

1.  In that same black window (Command Prompt), type:
    ```cmd
    python study.py status
    ```
2.  You should see your **Clinical Dashboard** appear!

---

## ✅ You Are Ready!
You have successfully set up your Medical Mastery OS. You can now follow the **[Oncology Mastery Cookbook](oncology-mastery.md)** to begin your project.

### 💡 Pro-Tip for Windows:
If you ever want to update the system to get the latest clinical features, just open **GitHub Desktop** and click **"Fetch Origin"** at the top.

**Navigation**
[📖 Back to Manual](manual.md) | [🏠 Home](../../README.md)
