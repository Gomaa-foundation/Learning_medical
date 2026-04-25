# 🔑 Cookbook: Setting Up Secure Access (SSH)

Setting up an "SSH Key" is like creating a permanent, secure badge for your computer. It allows you to sync your medical knowledge with GitHub without having to type your password every single time.

---

## 1. Generate Your Security Key
1.  Open your **Command Prompt** (type `cmd` in the Start menu).
2.  Type the following command (replace the email with your GitHub email):
    ```cmd
    ssh-keygen -t ed25519 -C "your_email@example.com"
    ```
3.  When it asks where to save the file, just press **Enter** (the default is perfect).
4.  When it asks for a "passphrase," you can just press **Enter** twice to keep it simple (unless you want an extra layer of security).

---

## 2. Copy Your New Key
Now we need to copy the "public" part of your key to give to GitHub.

1.  In the same Command Prompt, type:
    ```cmd
    type %USERPROFILE%\.ssh\id_ed25519.pub
    ```
2.  Highlight the text that appears (it will start with `ssh-ed25519` and end with your email).
3.  **Right-click** to copy the highlighted text.

---

## 3. Add the Key to GitHub
1.  Log in to your account at [GitHub.com](https://github.com).
2.  Click your **Profile Picture** in the top right and select **"Settings"**.
3.  On the left sidebar, click **"SSH and GPG keys"**.
4.  Click the green button: **"New SSH key"**.
5.  Give it a Title (e.g., "My Medical Laptop").
6.  Paste your key into the **"Key"** box.
7.  Click **"Add SSH key"**.

---

## 4. Final Test
In your Command Prompt, type:
```cmd
ssh -T git@github.com
```
If you see a message saying *"Hi [Your Name]! You've successfully authenticated"*, you are all set! You never have to worry about passwords for this system again.

---

**Navigation**
[📖 Back to Manual](manual.md) | [🏠 Home](../../README.md)
