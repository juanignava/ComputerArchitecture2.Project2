# IMPORTS
import numpy as np
#import imageio
import imageio.v2 as imageio

# CONSTANS
IMAGE_PATH = "Images/dog.jpeg"
IMAGE_SAVE_PATH = "TextFiles/inputPixels.txt"
IMAGE_SIZE_X = 250
IMAGE_SIZE_Y = 200

# AUXILIAR IMAGE FUNTIONS

"""
Description: function that receives the path of an image and creates a list of all the pixels in RGB
"""
def readImage(path):

    array = np.array(imageio.imread(path), dtype='int').tolist()
    list = []

    for y in range(IMAGE_SIZE_Y):

        for x in range(IMAGE_SIZE_X):

            for pix in range(3):

                list.append(array[y][x][pix])

    return list

"""
Description: function that receives a list of pixels in RGB and converts them into hex representation
"""
def decimalToHex(list):

    size = len(list)

    for i in range(size):

        list[i] = hex(list[i])

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
