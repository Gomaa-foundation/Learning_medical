import os
import glob
import pandas as pd

def process_ckds(src_dir):
    """
    Kaggle-Native logic to clean and merge the distilled CKDs.
    Proof of processing for Sovereign German Acquisition.
    """
    ckd_files = glob.glob(os.path.join(src_dir, "*.md"))
    results = []
    
    for ckd in ckd_files:
        with open(ckd, 'r') as f:
            content = f.read()
            results.append({
                "source": os.path.basename(ckd),
                "length": len(content),
                "keywords": [line for line in content.split('\n') if line.startswith('##')]
            })
            
    return pd.DataFrame(results)

if __name__ == "__main__":
    # In Kaggle, the input directory would be /kaggle/input/sovereign-german-distillations
    df = process_ckds("./knowledge-base/german/sources")
    print("Sovereign German Processing Audit:")
    print(df)
