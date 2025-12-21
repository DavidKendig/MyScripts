#!/usr/bin/env python3
"""
Code to Markdown Converter

This script searches the current directory for .java and .py files
and converts them to markdown format with proper syntax highlighting.
"""

import os
import glob
from pathlib import Path
from datetime import datetime


def get_language_tag(file_extension):
    """Return the appropriate markdown language tag for syntax highlighting."""
    language_map = {
        '.py': 'python',
        '.java': 'java'
    }
    return language_map.get(file_extension, '')


def convert_file_to_markdown(file_path, output_dir='markdown_output'):
    """
    Convert a code file to markdown format.

    Args:
        file_path: Path to the code file
        output_dir: Directory to save markdown files
    """
    file_path = Path(file_path)

    # Read the source file
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            code_content = f.read()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None

    # Get the language tag
    language_tag = get_language_tag(file_path.suffix)

    # Get current date and time
    current_datetime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Create markdown content
    markdown_content = f"""**File Type:** {language_tag.capitalize()}
**Converted on:** {current_datetime}

---

## Code

```{language_tag}
{code_content}
```
"""

    # Create output directory if it doesn't exist
    output_path = Path(output_dir)
    output_path.mkdir(exist_ok=True)

    # Create output filename with language type
    output_file = output_path / f"{file_path.stem}_{language_tag}.md"

    # Write markdown file
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(markdown_content)
        print(f"✓ Converted: {file_path.name} -> {output_file}")
        return output_file
    except Exception as e:
        print(f"✗ Error writing {output_file}: {e}")
        return None


def find_and_convert_code_files():
    """
    Find all .java and .py files in the current directory and convert them.
    """
    # Get the directory where this script is located
    script_dir = Path(__file__).parent
    os.chdir(script_dir)

    print(f"Searching for code files in: {script_dir}\n")

    # Find all Java and Python files
    patterns = ['*.java', '*.py']
    code_files = []

    for pattern in patterns:
        files = list(script_dir.glob(pattern))
        code_files.extend(files)

    # Exclude this script itself
    script_name = Path(__file__).name
    code_files = [f for f in code_files if f.name != script_name]

    if not code_files:
        print("No .java or .py files found in the current directory.")
        return

    print(f"Found {len(code_files)} file(s) to convert:\n")

    # Convert each file
    converted_count = 0
    for file_path in sorted(code_files):
        result = convert_file_to_markdown(file_path)
        if result:
            converted_count += 1

    print(f"\n{'='*50}")
    print(f"Conversion complete!")
    print(f"Files converted: {converted_count}/{len(code_files)}")
    print(f"Output directory: {Path('markdown_output').absolute()}")
    print(f"{'='*50}")


if __name__ == '__main__':
    find_and_convert_code_files()
