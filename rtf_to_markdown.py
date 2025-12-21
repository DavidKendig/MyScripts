#!/usr/bin/env python3
"""
RTF to Markdown Converter

This script converts RTF (Rich Text Format) documents to Markdown format.
It searches the current directory for .rtf files and converts them.
Automatically installs required dependencies if missing.
"""

import os
import re
import subprocess
import sys
from pathlib import Path
from datetime import datetime

try:
    from striprtf.striprtf import rtf_to_text
    STRIPRTF_AVAILABLE = True
except ImportError:
    STRIPRTF_AVAILABLE = False

try:
    import pypandoc
    PYPANDOC_AVAILABLE = True
except ImportError:
    PYPANDOC_AVAILABLE = False


def install_packages():
    """Install required packages using pip."""
    packages = []

    if not STRIPRTF_AVAILABLE:
        packages.append('striprtf')
    if not PYPANDOC_AVAILABLE:
        packages.append('pypandoc')

    if not packages:
        return True

    print("\n" + "="*50)
    print(f"Installing required packages: {', '.join(packages)}...")
    print("="*50)

    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install"] + packages)
        print("\n" + "="*50)
        print(f"✓ Successfully installed packages!")
        print("="*50)
        return True
    except subprocess.CalledProcessError as e:
        print("\n" + "="*50)
        print(f"✗ Failed to install packages: {e}")
        print("="*50)
        print("Please try installing manually with:")
        print(f"    python -m pip install {' '.join(packages)}")
        return False


def clean_markdown(text):
    """Clean up the converted markdown text."""
    # Remove excessive blank lines (more than 2 consecutive)
    text = re.sub(r'\n{3,}', '\n\n', text)
    # Strip leading/trailing whitespace
    text = text.strip()
    return text


def ensure_pandoc_installed():
    """Ensure Pandoc is installed for pypandoc to use."""
    if not PYPANDOC_AVAILABLE:
        return False

    try:
        # Try to get pandoc version to check if it's installed
        import pypandoc as pd
        pd.get_pandoc_version()
        return True
    except OSError:
        # Pandoc not found, try to download it
        print("\n" + "="*50)
        print("Pandoc executable not found.")
        print("Attempting to download Pandoc...")
        print("="*50)
        try:
            import pypandoc as pd
            pd.download_pandoc()
            print("\n" + "="*50)
            print("✓ Pandoc downloaded successfully!")
            print("="*50)
            return True
        except Exception as e:
            print("\n" + "="*50)
            print(f"✗ Failed to download Pandoc: {e}")
            print("="*50)
            return False


def convert_rtf_with_pandoc(rtf_file_path):
    """
    Convert RTF to Markdown using pypandoc (preserves tables).

    Args:
        rtf_file_path: Path to the RTF file

    Returns:
        Converted markdown text or None on error
    """
    try:
        # Use pypandoc to convert RTF to Markdown
        markdown_text = pypandoc.convert_file(
            str(rtf_file_path),
            'markdown',
            format='rtf',
            extra_args=['--wrap=none']
        )
        return markdown_text
    except OSError as e:
        if "pandoc" in str(e).lower():
            print(f"  Warning: Pandoc not available: {e}")
            # Try to install pandoc
            if ensure_pandoc_installed():
                # Try conversion again
                try:
                    markdown_text = pypandoc.convert_file(
                        str(rtf_file_path),
                        'markdown',
                        format='rtf',
                        extra_args=['--wrap=none']
                    )
                    return markdown_text
                except Exception as retry_error:
                    print(f"  Warning: Retry failed: {retry_error}")
                    return None
        return None
    except Exception as e:
        print(f"  Warning: pypandoc conversion failed: {e}")
        return None


def convert_rtf_with_striprtf(rtf_file_path):
    """
    Convert RTF to plain text using striprtf (fallback, no table support).

    Args:
        rtf_file_path: Path to the RTF file

    Returns:
        Converted text or None on error
    """
    try:
        with open(rtf_file_path, 'r', encoding='utf-8', errors='ignore') as f:
            rtf_content = f.read()
        plain_text = rtf_to_text(rtf_content)
        return plain_text
    except Exception as e:
        print(f"  Warning: striprtf conversion failed: {e}")
        return None


def convert_rtf_to_markdown(rtf_file_path, output_dir='markdown_output'):
    """
    Convert an RTF file to markdown format using both converters.

    Args:
        rtf_file_path: Path to the RTF file
        output_dir: Directory to save markdown files
    """
    rtf_file_path = Path(rtf_file_path)

    # Create output directory if it doesn't exist
    output_path = Path(output_dir)
    output_path.mkdir(exist_ok=True)

    # Get current date and time
    current_datetime = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    converted_files = []

    # Try pypandoc conversion (best table support)
    if PYPANDOC_AVAILABLE:
        markdown_text = convert_rtf_with_pandoc(rtf_file_path)
        if markdown_text is not None:
            # Clean up the markdown
            markdown_text = clean_markdown(markdown_text)

            # Create markdown content with pypandoc label
            markdown_content = f"""**File Type:** RTF
**Converted on:** {current_datetime}
**Converter:** pypandoc (with table support)

---

{markdown_text}
"""

            # Create output filename with pypandoc suffix
            output_file = output_path / f"{rtf_file_path.stem}_pypandoc.md"

            # Write markdown file
            try:
                with open(output_file, 'w', encoding='utf-8') as f:
                    f.write(markdown_content)
                print(f"✓ Converted with pypandoc: {rtf_file_path.name} -> {output_file.name}")
                converted_files.append(output_file)
            except Exception as e:
                print(f"✗ Error writing pypandoc output {output_file}: {e}")

    # Try striprtf conversion
    if STRIPRTF_AVAILABLE:
        plain_text = convert_rtf_with_striprtf(rtf_file_path)
        if plain_text is not None:
            # Clean up the text
            plain_text = clean_markdown(plain_text)

            # Create markdown content with striprtf label
            markdown_content = f"""**File Type:** RTF
**Converted on:** {current_datetime}
**Converter:** striprtf (tables not preserved)

---

{plain_text}
"""

            # Create output filename with striprtf suffix
            output_file = output_path / f"{rtf_file_path.stem}_striprtf.md"

            # Write markdown file
            try:
                with open(output_file, 'w', encoding='utf-8') as f:
                    f.write(markdown_content)
                print(f"✓ Converted with striprtf: {rtf_file_path.name} -> {output_file.name}")
                converted_files.append(output_file)
            except Exception as e:
                print(f"✗ Error writing striprtf output {output_file}: {e}")

    if not converted_files:
        print(f"✗ Failed to convert {rtf_file_path.name} with any converter")
        return None

    return converted_files


def find_and_convert_rtf_files():
    """
    Find all .rtf files in the current directory and convert them.
    """
    global STRIPRTF_AVAILABLE, PYPANDOC_AVAILABLE

    # Check if pypandoc is available (preferred for table support)
    if not PYPANDOC_AVAILABLE:
        print("\n" + "="*50)
        print("NOTICE: 'pypandoc' is not installed.")
        print("This package is needed for proper table conversion.")
        if STRIPRTF_AVAILABLE:
            print("'striprtf' is installed but doesn't preserve tables.")
        print("="*50)

        # Ask user if they want to install pypandoc
        response = input("\nWould you like to install pypandoc now? (y/n): ").strip().lower()

        if response == 'y' or response == 'yes':
            if install_packages():
                # Try importing again
                try:
                    from striprtf.striprtf import rtf_to_text
                    STRIPRTF_AVAILABLE = True
                    globals()['rtf_to_text'] = rtf_to_text
                except ImportError:
                    pass

                try:
                    import pypandoc
                    PYPANDOC_AVAILABLE = True
                    globals()['pypandoc'] = pypandoc
                except ImportError:
                    pass

                if PYPANDOC_AVAILABLE:
                    print("\n" + "="*50)
                    print("✓ pypandoc successfully installed!")
                    print("="*50)
                else:
                    print("\n" + "="*50)
                    print("WARNING: pypandoc installation may have failed.")
                    if STRIPRTF_AVAILABLE:
                        print("Will use striprtf as fallback (tables may be broken).")
                    print("="*50)

                print("\nResuming conversion...\n")
            else:
                if STRIPRTF_AVAILABLE:
                    print("\nContinuing with striprtf (tables may be broken)...\n")
                else:
                    print("\nCannot proceed without any converter package.")
                    return
        else:
            if STRIPRTF_AVAILABLE:
                print("\nContinuing with striprtf (tables may be broken)...\n")
            else:
                print("\nCannot proceed without any converter package.")
                return

    # Final check - make sure we have at least one converter
    if not STRIPRTF_AVAILABLE and not PYPANDOC_AVAILABLE:
        print("\n" + "="*50)
        print("ERROR: No conversion package available.")
        print("Please install at least one of: pypandoc, striprtf")
        print("="*50)
        return

    # If pypandoc is available, ensure Pandoc executable is installed
    if PYPANDOC_AVAILABLE:
        if not ensure_pandoc_installed():
            print("\n" + "="*50)
            print("WARNING: Pandoc executable could not be installed.")
            if STRIPRTF_AVAILABLE:
                print("Will use striprtf as fallback (tables may be broken).")
            else:
                print("Cannot proceed without a working converter.")
                print("="*50)
                return
            print("="*50)

    # Get the directory where this script is located
    script_dir = Path(__file__).parent
    os.chdir(script_dir)

    print(f"Searching for RTF files in: {script_dir}\n")

    # Find all RTF files
    rtf_files = list(script_dir.glob('*.rtf'))

    if not rtf_files:
        print("No .rtf files found in the current directory.")
        return

    print(f"Found {len(rtf_files)} RTF file(s) to convert:\n")

    # Convert each file
    converted_count = 0
    total_output_files = 0
    for file_path in sorted(rtf_files):
        print(f"\nConverting: {file_path.name}")
        result = convert_rtf_to_markdown(file_path)
        if result:
            converted_count += 1
            total_output_files += len(result)

    print(f"\n{'='*50}")
    print(f"Conversion complete!")
    print(f"Source files processed: {converted_count}/{len(rtf_files)}")
    print(f"Output files created: {total_output_files}")
    print(f"Output directory: {Path('markdown_output').absolute()}")
    print(f"{'='*50}")


if __name__ == '__main__':
    try:
        find_and_convert_rtf_files()
    except Exception as e:
        print("\n" + "="*50)
        print(f"ERROR: An unexpected error occurred:")
        print(f"    {type(e).__name__}: {e}")
        print("="*50)
        import traceback
        traceback.print_exc()
    finally:
        print("\nPress Enter to exit...")
        input()
