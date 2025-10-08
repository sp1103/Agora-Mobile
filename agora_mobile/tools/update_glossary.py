#AI CODE START
import json
import os

# Path to your glossary file (you can adjust this)
GLOSSARY_PATH = os.path.join(os.path.dirname(__file__), "..", "assets", "senate_glossary.json")

def load_glossary():
    if not os.path.exists(GLOSSARY_PATH):
        return []

    with open(GLOSSARY_PATH, "r", encoding="utf-8") as f:
        try:
            return json.load(f)
        except json.JSONDecodeError:
            print("⚠️  Warning: JSON file is empty or invalid. Starting fresh.")
            return []

def save_glossary(glossary):
    with open(GLOSSARY_PATH, "w", encoding="utf-8") as f:
        json.dump(glossary, f, ensure_ascii=False, indent=4)

def main():
    glossary = load_glossary()

    # Create a set of existing terms for fast lookup
    existing_terms = {entry["term"].lower() for entry in glossary if "term" in entry}

    print("📘 Senate Glossary Editor")
    print("Type a term and definition. Press Ctrl+C to stop.\n")

    try:
        while True:
            term = input("Term: ").strip()
            if not term:
                print("❌ Term cannot be empty.")
                continue

            if term.lower() in existing_terms:
                print(f"⚠️  '{term}' already exists — skipping.\n")
                continue

            definition = input("Definition: ").strip()
            if not definition:
                print("❌ Definition cannot be empty.")
                continue

            glossary.append({"term": term, "definition": definition})
            existing_terms.add(term.lower())
            save_glossary(glossary)

            print(f"✅ Added '{term}'\n")

    except KeyboardInterrupt:
        print("\n👋 Exiting gracefully. All changes saved.")
        save_glossary(glossary)

if __name__ == "__main__":
    main()
#AI CODE END