# IMPORTS
from ast import Return
import numpy as np
#import imageio
import imageio.v2 as imageio

# CONSTANS
IMAGE_PATH = "Images/dog.jpeg"
IMAGE_SAVE_PATH = "imageData.txt"

# AUXILIAR IMAGE FUNTIONS

"""
Description: function that receives the path of an image and creates a list of all the pixels in RGB
"""
def readImage(path):
    return np.array(imageio.imread(path), dtype='int').flatten().tolist()

"""
Description: function that receives a list of pixels in RGB and converts them into hex representation
"""
def decimalToHex(list):
    size = len(list)

    for i in range(size):
        elem = str(bin(list[i])[2:])
        complete = 32 - len(elem)
        for j in range(complete):
            elem = '0' + elem
        list[i] = elem

    return list

"""
Desciption: function that saves the list on a file as a text given a path
"""
def saveListFile(path, list):

    f = open(path, "w")

    for i in list:

        f.write(i)
        f.write("\n")

    f.close()

# MAIN PROGRAM
imageList = readImage(IMAGE_PATH)
imageList = decimalToHex(imageList)
saveListFile(IMAGE_SAVE_PATH, imageList)
