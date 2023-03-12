#!/bin/bash

# Usage:
# ./download.sh <root_url> <output_directory> <text_file_with_list_of_folders>
# ./download.sh http://serials.flib.sci.am/openreader/ /home/user/Downloads/folders/ folders.txt

# define a function to print the usage
function printUsage {
  echo "Usage: ./download.sh <root_url> <output_directory> <text_file_with_list_of_folders>"
  echo "text_file_with_list_of_folders is optional, if not provided, the script will download all folders."
}

# get the first argument as the root URL
rootURL=$1
# check if root URL not provided, if not, exit
if [ -z $rootURL ]; then
  echo "Root URL not provided!"
  printUsage
  exit
fi
# check if the URL ends with a slash, if not, add it
if [[ $rootURL != */ ]]; then
  rootURL=$rootURL"/"
fi
# send test request and check if the URL is valid
if ! curl --output /dev/null --silent --head --fail $rootURL; then
  echo "Root URL "$rootURL" is not valid!"
  printUsage
  exit
fi

# get the second argument as the output directory
outputDir=$2
# check if output directory not provided, if not, exit
if [ -z $outputDir ]; then
  echo "Output directory not provided!"
  printUsage
  exit
fi
# check if output directory exists, if not exit
if [ ! -d $outputDir ]; then
  echo "Output directory "$outputDir" doesn't exist!"
  printUsage
  exit
fi
# check if output directory ends with a slash, if not, add it
if [[ $outputDir != */ ]]; then
  outputDir=$outputDir"/"
fi

# get the third argument as the name of the file with the list of folders
foldersFile=$3
# check if the file name not provided, if not, exit
if [ -z $foldersFile ]; then
  # create temporary file with the list of all folders
  foldersFile=$(mktemp)
  echo "Temporary file "$foldersFile" created."

  # way 1 (with python script)
#   # run the extract-folders.py script and save the result in the variable
#   folders=$(python extract-folders.py $rootURL)
#   # loop through the folders array and write each folder to the file as a new line
#   for folder in $folders
#   do
#     # ['test/'], -> test/
#     # print without quotes, comma and square brackets
#     folder=$(echo $folder | sed "s/'//g" | sed "s/,//g" | sed "s/\[//g" | sed "s/\]//g")
#     echo $folder >> $foldersFile
#   done

  # way 2 (with curl / without python script)
  # retrieve all the folder names in the root URL and store them in a file called $foldersFile
  curl -s $rootURL | grep -oP '(?<=href=")[^"]*' | grep -v "Parent Directory" > $foldersFile
  # remove first 5 lines from the file $foldersFile
  sed -i '1,5d' $foldersFile
else
  # check if the file exists, if not, exit
  if [ ! -f $foldersFile ]; then
    echo "File "$foldersFile" doesn't exist!"
    printUsage
    exit
  fi
fi

echo "Found directories count: "$(wc -l $foldersFile | awk '{print $1}')
echo ""

# check if the file is empty, if yes, exit
if [ ! -s $foldersFile ]; then
  echo "Something went wrong!"
  exit
fi

while read line
do
  encodedLine=$(echo $line | sed 's/ /%20/g')
  # check if encodedLine is ending with a slash, if not, add it
  if [[ $encodedLine != */ ]]; then
    encodedLine=$encodedLine"/"
  fi

  # create a $outputDir folder with the name of the line, if not exists
  if [ ! -d $outputDir$encodedLine ]; then
    mkdir $outputDir$encodedLine
  fi

  # define a bookURL prefix with encoded line
  bookURL=$rootURL$encodedLine"book/"

  # define first file name
  fileNameZerosCount=2
  lastFileName=99
  if ! curl --output /dev/null --silent --head --fail $bookURL"01.jpg"; then
    fileNameZerosCount=3
    lastFileName=999
    if ! curl --output /dev/null --silent --head --fail $bookURL"001.jpg"; then
      fileNameZerosCount=4
      lastFileName=9999
      if ! curl --output /dev/null --silent --head --fail $bookURL"0001.jpg"; then
        fileNameZerosCount=0
      fi
    fi
  fi

  # check if fileNameZerosCount is not 0
  if [ $fileNameZerosCount -ne 0 ]; then
    # iterate from firstFileName to lastFileName while checking if the URL exists
    # (file URL example: $rootURL/$encodedLine/book/$firstFileName.jpg)
    # if the URL exists, download the file and save it in the folder with the name of the line
    # otherwise, stop the loop
    for i in $(seq -f "%0"$fileNameZerosCount"g" 1 $lastFileName)
    do
      # check if the file already exists in the output directory
      if [ ! -f $outputDir$encodedLine$i".jpg" ]; then
        if curl --output /dev/null --silent --head --fail $bookURL$i".jpg"; then
          # inform the user that the file is downloading
          echo $bookURL$i".jpg downloading to "$outputDir$encodedLine$i".jpg"
          curl -s $bookURL$i".jpg" -o $outputDir$encodedLine$i".jpg"
        else
          break
        fi
      else
        echo $outputDir$encodedLine$i".jpg already exists"
      fi
    done
    # inform the user that the folder is done
    echo ">>>>>>>>>>>>>>>>> " $encodedLine "done"
  else
    # inform the user that the folder is empty
    echo "----------------- " $encodedLine "empty"
  fi
done < $foldersFile
