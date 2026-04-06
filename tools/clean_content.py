import os
import re

def clean_markdown_files(directories):
    for directory in directories:
        if not os.path.exists(directory):
            continue
            
        for filename in os.listdir(directory):
            if filename.endswith(".md"):
                filepath = os.path.join(directory, filename)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()

                original_content = content
                
                # Fix weird spacing before commas, e.g., "Name , Name" -> "Name, Name"
                # Need to be careful not to break standard spacing, but " , " is almost always a typo.
                content = re.sub(r'\s+,', ',', content)
                
                # Make sure permalink ends with a slash (just making sure the user's recent changes are consistent)
                def fix_permalink(match):
                    link = match.group(1)
                    if not link.endswith('/'):
                        # If the permalink has quotes, preserve them
                        if link.endswith('"') and not link.endswith('/"'):
                            return f'permalink: {link[:-1]}/"'
                        elif link.endswith('\'') and not link.endswith("/'"):
                            return f"permalink: {link[:-1]}/'"
                        else:
                            return f"permalink: {link}/"
                    return match.group(0)

                content = re.sub(r'^permalink:\s*(.+?)\s*$', fix_permalink, content, flags=re.MULTILINE)

                if content != original_content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(content)
                    print(f"Cleaned {filepath}")

if __name__ == "__main__":
    clean_markdown_files(["_publications", "_shortpapers"])
    print("Cleanup complete.")
