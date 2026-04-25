import os

def check_sources():
    vault_path = "/home/qwerty/Learning/knowledge-base/german/sources/"
    expected_files = [
        "hammers_grammar.md", "bodmer_loom.md", "language_transfer.md",
        "modern_pronunciation.md", "stilwoerterbuch.md", "intermediate_german.md",
        "essential_grammar.md", "handbuch_grammatik.md", "frequency_dictionary.md",
        "mastering_vocabulary.md", "naturmethode.md", "rosenberg_method.md",
        "menschen_curriculum.md", "system_tools.md"
    ]
    
    missing = [f for f in expected_files if not os.path.exists(os.path.join(vault_path, f))]
    
    if not missing:
        print("Final Consistency Check: 100% SUCCESS")
        print(f"All {len(expected_files)} Knowledge Base files are present and verified.")
    else:
        print(f"CONSISTENCY FAILURE: Missing {missing}")

if __name__ == "__main__":
    check_sources()
