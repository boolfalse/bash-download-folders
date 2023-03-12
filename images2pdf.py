
# Author: [BoolFalse](https://boolfalse.com/)
# Description: Python Script to convert multiple images to a single pdf file

# Usage: python images2pdf.py <images_folder_path> <output_file_path>

# import the necessary packages
from PIL import Image
import os
import sys

# check if the number of parameters is 3
if len(sys.argv) != 3:
    print("Invalid number of parameters!")
    print("Usage: python images2pdf.py <images_folder_path> <output_file_path>")
    print("Example: python images2pdf.py ~/Desktop/images ~/Desktop/output.pdf")
    sys.exit()

# get first parameter as the images folder
imagesFolder = sys.argv[1]

# check if the images folder exists
if not os.path.exists(imagesFolder):
    print("Images folder does not exist!")
    sys.exit()

# get second parameter as the output pdf file path
outputPdf = sys.argv[2]

# check if the output pdf file exists
if os.path.exists(outputPdf):
    print("Output pdf file already exists!")
    sys.exit()

# check if the output pdf file has .pdf extension
if not outputPdf.endswith(".pdf"):
    print("Output pdf file must have .pdf extension!")
    sys.exit()

# create pdf file
open(outputPdf, 'a').close()
# open(outputPdf, "wb")

# get all images in the folder ordered by name
imgList = sorted(os.listdir(imagesFolder))

convertedImgList=[]
try:
    for image in imgList:
        # minimize the image size and convert it to RGB
        img = Image.open(imagesFolder + "/" + image).convert('RGB')
        # TODO: improve image manipulation to make it more efficient
        # make image maximum width 1123 pixels and height 794 pixels
        # img.thumbnail((1123, 794)) # 1123x794 is the size of A4 paper
        # append the image to the list
        convertedImgList.append(img)
        # convert the image to RGB
        img.convert('RGB')

    # get the first image
    firstImg=convertedImgList.pop(0)

    # save the pdf file
    firstImg.save(outputPdf, "PDF", resolution=100.0, save_all=True, append_images=convertedImgList)
except:
    print("Error in folder: " + imagesFolder)
