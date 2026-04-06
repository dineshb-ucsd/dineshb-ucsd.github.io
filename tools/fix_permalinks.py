import os
import re

def fix_permalinks():
    directories = ["_publications", "_shortpapers"]
    for d in directories:
        if not os.path.exists(d):
            continue
        for f in os.listdir(d):
            if f.endswith(".md"):
                p = os.path.join(d, f)
                with open(p, 'r') as file:
                    content = file.read()
                
                # Fix permalink: "/path/"/
                new_content = re.sub(r'permalink:\s*"([^"]+)"/', r'permalink: "\1"', content)
                # Fix permalink: '/path/'/
                new_content = re.sub(r"permalink:\s*'([^']+)'/", r"permalink: '\1'", new_content)
                # Fix permalink: /path//
                new_content = re.sub(r'permalink:\s*([^\'"]+)//$', r'permalink: \1/', new_content, flags=re.MULTILINE)
                
                if new_content != content:
                    with open(p, 'w') as file:
                        file.write(new_content)
                    print("Fixed", p)

if __name__ == "__main__":
    fix_permalinks()
