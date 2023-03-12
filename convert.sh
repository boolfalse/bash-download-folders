#!/bin/bash

# Usage
# ./convert.sh <input_directory_path> <output_directory_path>
# ./convert.sh /home/user/Downloads/folders/ /home/user/Downloads/pdfs/

# loop over all the directories in the input directory
# for each subdirectory create a pdf file with the same name

# define a function to print the usage
function printUsage {
  echo "Usage: ./convert.sh <input_directory_path> <output_directory_path>"
}

# get the second argument as the output directory
inputDir=$1
# check if output directory not provided, if not, exit
if [ -z $inputDir ]; then
  echo "Input directory not provided!"
  printUsage
  exit
fi
# check if output directory exists, if not exit
if [ ! -d $inputDir ]; then
  echo "Input directory $inputDir doesn't exist!"
  printUsage
  exit
fi
# check if input directory ends with a slash, if not, add it
if [[ $inputDir != */ ]]; then
  inputDir=$inputDir"/"
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

# loop through all folders in input folder
for dir in "$inputDir"*; do
  # check if $dir is a directory
  if [ -d "$dir" ]; then
    # get directory name. the name could contain spaces, so we need to use quotes
    folderName=$(basename "$dir")
    # check if exists $dir".pdf" file in the output directory
    if [ ! -f $outputDir$folderName".pdf" ]; then
      echo "Processing $dir..."
      # run python command
      python images2pdf.py "$dir" $outputDir$folderName".pdf"
    fi
  fi
done
