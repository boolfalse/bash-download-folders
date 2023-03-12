
## Download all the folder files from remote URL



#### Prerequisites:

- Python 3.6+ (Optional, if you want to use the script to download all the folders)



#### Usage:

- Clone the repository:
```bash
git clone git@github.com:boolfalse/bash-download-folders.git && cd bash-download-folders
```

- Change shell script permissions:
```bash
chmod +x download.sh
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
```

- Example:
```bash
./download.sh http://serials.flib.sci.am/openreader/ /home/user/Downloads/ folders.txt
```

- Params:
> *root_url* is a valid URL to the folders.
> *output_directory* is the directory where the folders will be downloaded to.
> *text_file_with_list_of_folders* is optional, if not provided, the script will download all folders.




#### Author:

- [BoolFalse](https://boolfalse.com/)
