# ☁️ Cookbook: Setting Up Your Cloud Supercomputer (Kaggle)

To process your 1100-page Oncology research book, our system uses a "Cloud Supercomputer" (Kaggle) to do the heavy lifting. This allows us to convert complex medical diagrams and dense research papers into clean notes in minutes instead of hours.

Setting this up is a one-time process and takes about 5 minutes.

---

## 1. Create Your Kaggle Account
If you don't have one yet, visit [Kaggle.com](https://www.kaggle.com) and sign up (using your Google account is the easiest way).

## 2. Generate Your "Access Key"
Think of this as a digital key that allows your Medical OS to talk to the Cloud Supercomputer securely.

1.  Log in to Kaggle.
2.  Click on your **Profile Picture** in the top right corner and select **"Settings"**.
3.  Scroll down to the **"API"** section.
4.  Click the button that says **"Create New Token"**.
5.  A file named `kaggle.json` will automatically download to your computer. **Keep this file safe!**

## 3. Activate the Key
Now we need to put that key in the right place so the system can find it.

### If you are on Mac or Linux:
1.  Open your **Terminal**.
2.  Type these two commands (you can copy and paste them):
    ```bash
    mkdir -p ~/.kaggle
    cp ~/Downloads/kaggle.json ~/.kaggle/
    chmod 600 ~/.kaggle/kaggle.json
    ```

### If you are on Windows:
1.  Open your **File Explorer**.
2.  Go to your User folder (usually `C:\Users\YourName`).
3.  Create a new folder named `.kaggle` (note the dot at the beginning).
4.  Copy the `kaggle.json` file from your Downloads folder into this new `.kaggle` folder.

---

## 4. Final Step: Phone Verification
Kaggle requires you to verify your phone number to use their free "Supercomputer" (GPU) time.

1.  Go to [Kaggle.com/settings](https://www.kaggle.com/settings).
2.  In the **"Phone Verification"** section, add and verify your number.
3.  This ensures you get **30 hours of free processing every week**, which is more than enough for your 1100-page project!

---

## ✅ You Are Ready!
Now, whenever you drop a large book into your `input-library/` and type `/orchestrate`, I will handle the cloud connection automatically. You don't need to do anything else technical!

**Navigation**
[📖 Back to Cookbooks](manual.md) | [🏠 Home](../../README.md)
