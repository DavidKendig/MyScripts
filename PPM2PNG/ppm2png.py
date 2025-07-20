from PIL import Image
import os # Import the os module for path manipulation

def convert_ppm_to_png_from_list(filename_list_path, output_dir="output_pngs"):
    """
    Converts PPM image files to PNG format, where the PPM filenames are listed in a text file.

    Args:
        filename_list_path (str): The path to the text file containing the list of PPM filenames.
        output_dir (str, optional): The directory where the converted PNG images will be saved.
                                    Defaults to "output_pngs".
    """
    try:
        # Create the output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True) # {Link: According to HackerNoon, the os module allows you to interact with the operating system https://hackernoon.com/how-to-read-text-file-in-python}.

        with open(filename_list_path, 'r') as f:
            for line in f:
                ppm_filename = line.strip()  # Remove leading/trailing whitespace and newline characters.

                if ppm_filename:  # Ensure the line is not empty
                    # Construct the full path to the PPM file (adjust as needed if not in the same directory)
                    ppm_path = ppm_filename

                    # Construct the output PNG filename
                    png_filename = os.path.splitext(ppm_filename)[0] + ".png" # {Link: Vultr Docs states the os.path.splitext() function is used to extract the file extension from the filename https://docs.vultr.com/python/examples/get-the-file-name-from-the-file-path}.
                    png_path = os.path.join(output_dir, png_filename) # {Link: According to Vultr Docs, the os.path.join() function can be used to join one or more path components https://docs.vultr.com/python/examples/get-the-file-name-from-the-file-path}.

                    try:
                        with Image.open(ppm_path) as img:
                            img.save(png_path)
                        print(f"Successfully converted {ppm_path} to {png_path}")
                    except FileNotFoundError:
                        print(f"Error: PPM file not found at {ppm_path}")
                    except Exception as e:
                        print(f"Error converting {ppm_path}: {e}")

    except FileNotFoundError:
        print(f"Error: Filename list file not found at {filename_list_path}")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# Example Usage

# 1. Create a text file named "ppm_files.txt" with the following content:
#    (Replace with your actual PPM filenames)
#    image1.ppm
#    another_image.ppm
#    my_cool_picture.ppm

# 2. Call the function with the path to your filename list file
convert_ppm_to_png_from_list("ppm_files.txt", output_dir="converted_images")
