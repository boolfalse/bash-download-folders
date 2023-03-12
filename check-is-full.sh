#!/bin/bash

# Usage:
# ./check-is-full.sh <root_url> <output_directory>
# ./check-is-full.sh http://serials.flib.sci.am/openreader/ /home/user/Downloads/folders/

# define a function to print the usage
function printUsage {
  echo "Usage: ./check-is-full.sh <root_url> <output_directory>"
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
  echo "Root URL $rootURL is not valid!"
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
  echo "Output directory $outputDir doesn't exist!"
  printUsage
  exit
fi
# check if output directory ends with a slash, if not, add it
if [[ $outputDir != */ ]]; then
  outputDir=$outputDir"/"
fi

for folder in $outputDir/*; do
  if [ -d "$folder" ]; then
    folderName=$(basename "$folder") # get only folder name using basename
    lastFile=$(ls -1 "$folder" | tail -n 1) # get the last file in the folder (ordered by name)
    lastFileName=$(echo $lastFile | cut -f 1 -d '.') # get lastFile name without extension
    fileExtension=$(echo $lastFile | cut -f 2 -d '.') # get lastFile extension
    lastFileNameLength=${#lastFileName} # get lastFileName characters count
    lastFileNameWithoutLeadingZeros=$(echo $lastFileName | sed 's/^0*//')
    nextNumber=$((lastFileNameWithoutLeadingZeros + 1))
    nextNumberLength=${#nextNumber}
    zerosDifference=$((lastFileNameLength - nextNumberLength))

    if [ $zerosDifference -gt 0 ]; then
      nextNumberWithLeadingZeros=$(printf "%0${zerosDifference}d%s" 0 $nextNumber) # add leading zeros to the beginning of the next number
    else
      nextNumberWithLeadingZeros=$nextNumber
    fi

    nextFileNameWithExtension=$nextNumberWithLeadingZeros"."$fileExtension # (jpg) get the next file name with extension
    nextFileUrl=$rootURL$folderName"/book/"$nextFileNameWithExtension # get the next file url
    nextFileUrlEncoded=$(echo $nextFileUrl | sed 's/ /%20/g') # url encode the next file url

    lastFileUrl=$rootURL$folderName"/book/"$lastFile # get the last file url
    lastFileUrlEncoded=$(echo $lastFileUrl | sed 's/ /%20/g') # url encode the last file url

    # check if the next file exists
    if curl --output /dev/null --silent --head --fail $nextFileUrlEncoded; then
      echo $nextFileUrlEncoded" exists! The folder $folderName wasn't downloaded completely."
    else
      echo $lastFileUrlEncoded" is the last file in the folder."
      echo $nextFileUrlEncoded" doesn't exist. It's ok."
    fi
  fi
done
