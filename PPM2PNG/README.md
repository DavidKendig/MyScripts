# PPM2PNG

Batch converts PPM image files to PNG format using a text file containing a list of PPM filenames.

## Prerequisites

- Python 3
- [Pillow](https://pypi.org/project/Pillow/) (PIL fork)

Install Pillow:

```bash
pip install Pillow
```

## Usage

### 1. Generate the file list

Run the included batch file to create a directory listing:

```cmd
outputPPMlist.bat
```

This creates `ppm_files.txt` containing the contents of the current directory. **Edit `ppm_files.txt` afterwards** to remove any non-PPM entries so it contains only the PPM filenames you want to convert, one per line:

```
image1.ppm
another_image.ppm
my_cool_picture.ppm
```

### 2. Run the converter

```bash
python ppm2png.py
```

The script reads `ppm_files.txt` and converts each listed PPM file to PNG. Converted images are saved to the `converted_images/` directory, which is created automatically if it doesn't exist.

## Configuration

To change the input list file or output directory, edit the function call at the bottom of `ppm2png.py`:

```python
convert_ppm_to_png_from_list("ppm_files.txt", output_dir="converted_images")
```

- First argument: path to the text file containing PPM filenames
- `output_dir`: directory where PNG files will be saved
