# IMPORTS
import numpy as np
#import imageio
import imageio.v2 as imageio

# CONSTANS
IMAGE_SAVE_PATH = "Images/dog_output.jpeg"
FILE_PATH_READ = "imageOutput.txt"
IMAGE_SIZE_X = 100
IMAGE_SIZE_Y = 100

# AUXILIAR IMAGE FUNTIONS

"""
Desciption: function that reads pixels from a file and store them in a list
"""
def readListFile(path):

    list = []

    f = open(path, "r")

    lines = f.readlines()
    cont = 0
    for i in lines:
        if (cont < 3):
            cont += 1
            continue
        list.append(i)
        

    f.close()

    return list

"""
Description: function that receives a list of pixels in RGB and converts them into decimal representation
"""
def binToDecimal(list):

    size = len(list)

    for i in range(size):

        list[i] = int(list[i], 2)

    return list

"""
Description: function that receives a list of pixels in RGB and converts them into an image it also saves it
in the indicated path
"""
def saveImage(path, list):

    matrix = []

    for y in range(IMAGE_SIZE_Y):
        
        temp_list = []

        for x in range(IMAGE_SIZE_X):

            temp_pix = []

            for pix in range(3):

                elem = y * IMAGE_SIZE_X * 3 + x * 3 + pix

                if (elem == 0):
                    temp_pix.append(0)
                else:
                    temp_pix.append(list[elem])

            temp_list.append(temp_pix)

        matrix.append(temp_list)

    return imageio.imwrite(path, np.array(matrix, dtype='uint8'))

# MAIN PROGRAM
imageList = readListFile(FILE_PATH_READ)
imageList = binToDecimal(imageList)
saveImage(IMAGE_SAVE_PATH, imageList)
