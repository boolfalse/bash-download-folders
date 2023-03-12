
## Download folders (containing images) from a remote URL and convert them to PDFs.



#### Prerequisites:

- [OPTIONAL] Python 3.6+



#### Usage:

- Clone the repository:
```bash
git clone git@github.com:boolfalse/bash-download-folders.git && cd bash-download-folders
```

- Change shell scripts permissions:
```bash
chmod +x download.sh check-is-full.sh convert.sh
```

- Optional: Create a text file with the specific list of folders you want to download from the remote URL.
```bash
# Each folder should be on a new line. Example:
echo "A. Spendiarov-1950/" > folders.txt
echo "A. Spendiarov-1951/" >> folders.txt
echo "Abgar_1897/" >> folders.txt
```

- Download folders:
```bash
./download.sh <root_url> <output_directory> <text_file_with_list_of_folders>
# Example:
# ./download.sh http://serials.flib.sci.am/openreader/ /home/user/Downloads/folders/ folders.txt
```

- Params:
> *root_url* is a valid URL to the folders.
> *output_directory* is the directory where the folders will be downloaded to.
> *text_file_with_list_of_folders* is optional, if not provided, the script will download all folders.

- Check if all the folders (images) are downloaded completely:
```bash
./check-is-full.sh <root_url> <output_directory>
# Example:
# ./check-is-full.sh http://serials.flib.sci.am/openreader/ /home/user/Downloads/folders/
```

- Params:
> *root_url* is a valid URL to the folders.
> *output_directory* is the directory where the folders are downloaded to.

- Convert all the folders' files (images) to PDF:
```bash
./convert.sh <input_directory_path> <output_directory_path>
# Example:
# ./convert.sh /home/user/Downloads/folders/ /home/user/Downloads/pdfs/
```

- Params:
> *input_directory_path* is the directory where the folders are downloaded to.
> *output_directory_path* is the directory where the PDFs should be saved.



#### Author:

- [BoolFalse](https://boolfalse.com/)
