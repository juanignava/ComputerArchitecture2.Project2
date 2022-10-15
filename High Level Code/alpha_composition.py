# IMPORTS
import numpy as np
import imageio

# CONSTANS
IMAGE_PATH = "Images/dog.jpeg"
IMAGE_SAVE_PATH = "Images/dog_processed.jpeg"
FILE_PATH_READ = "TextFiles/readfile.txt"
IMAGE_SIZE_X = 250
IMAGE_SIZE_Y = 200

# AUXILIAR IMAGE FUNTIONS

"""
Description: function that receives the path of an image and creates a list of all the pixels in RGB
"""
def read_image(path):
    array = np.array(imageio.imread(path), dtype='int').tolist()
    list = []
    for y in range(IMAGE_SIZE_Y):
        for x in range(IMAGE_SIZE_X):
            for pix in range(3):
                list.append(array[y][x][pix])
    return list

"""
Description: function that receives a list of pixels in RGB and converts them into an image
it also saves it in the indicated path
"""
def save_image(path, list):
    matrix = []
    for y in range(IMAGE_SIZE_Y):
        temp_list = []
        for x in range(IMAGE_SIZE_X):
            temp_pix = []
            for pix in range(3):
                elem = y * IMAGE_SIZE_X * 3 + x * 3 + pix
                temp_pix.append(list[elem])
            temp_list.append(temp_pix)
        matrix.append(temp_list)

    return imageio.imwrite(path, np.array(matrix, dtype='uint8'))

"""
Desciption: function that saves the list on a file as a text given a path
This function is used for debugging
"""
def save_list_file(path, list):
    f = open(path, 'w')

    result = ""
    cont = 0
    for item in list:
        result += str(list[cont]) + " "
        if ((cont + 1) % IMAGE_SIZE_X == 0):
            result += "\n"
        cont += 1
    
    f.write(result)
    f.close()

# IMAGE ANALYSIS FUNCTIONS

"""
Description: shader function that creates the respective list with the shader effect
Inputs:
    R1, R0 -> bits that describe the red color in the shader
    G1, G0 -> bits that describe the green color in the shader
    B1, B0 -> bits that describe the blue color in the shader
    T1, T0 -> bits that describe the transparency of the received image

    type -> 0 corresponds to a vertical filter and 1 corresponds to the central vertical
        filter.
    list -> is the list of integers that represent the elements RGB pixels of the image

output:
    result -> is the list of integers that represent the elements of the RGB pixels of
        the shaded image
"""
def shader(R1, R0, G1, G0, B1, B0, T1, T0, type, list):

    # define basic variables
    red = 0
    green = 0
    blue = 0
    trans = 0

    # get red value
    if (R1 and R0):
        red = 255
    elif (R1):
        red = 191
    elif (R0):
        red = 63
    else:
        red = 0

    # get green value
    if (G1 and G0):
        green = 255
    elif (G1):
        green = 191
    elif (G0):
        green = 63
    else:
        green = 0

    # get blue value
    if (B1 and B0):
        blue = 255
    elif (B1):
        blue = 191
    elif (B0):
        blue = 63
    else:
        blue = 0

    # get transparency value
    if (T1 and T0):
        trans = 255
    elif (T1):
        trans = 191
    elif (T0):
        trans = 63
    else:
        trans = 0

    result = []

    # if the filter applied is the centered vertical shade
    if (type):
        red_p = 0
        green_p = 0
        blue_p = 0
        up = 1

        red_step = 2
        green_step = 2
        blue_step = 2

        for y in range(IMAGE_SIZE_Y):
            if (y >= IMAGE_SIZE_Y/2):
                up = 0
            if (up):
                if (red_p < red):
                    red_p += red_step
                if (green_p < green):
                    green_p += green_step
                if (blue_p < blue):
                    blue_p += blue_step
            else:
                if (red_p > 0):
                    red_p -= red_step
                if (green_p > 0):
                    green_p -= green_step
                if (blue_p > 0):
                    blue_p -= blue_step
            
            for x in range(0, IMAGE_SIZE_X, 2):
                elem = y * IMAGE_SIZE_X * 3 + x * 3 
                reg_list = [list[elem], list[elem+1], list[elem+2], list[elem+3], list[elem+4], list[elem+5]]
                reg_col = [red_p, green_p, blue_p, red_p, green_p, blue_p]
                reg_list_res = [0, 0, 0, 0, 0, 0]
                
                for i in range(6):
                    reg_col[i]  = reg_col[i] * trans
                    reg_col[i]  = reg_col[i] // 255

                for i in range(6):
                    reg_list[i] = reg_list[i] * (255 - trans)
                    reg_list[i] = reg_list[i] // 255

                for i in range(6):
                    reg_list_res[i] = reg_col[i] + reg_list[i]

                result += reg_list_res

        return result

    # if the filter applied is vertical
    else:

        red_step = 1
        green_step = 1
        blue_step = 1

        result = []

        for y in range(IMAGE_SIZE_Y):
            for x in range(0, IMAGE_SIZE_X, 2):
                elem = y * IMAGE_SIZE_X * 3 + x * 3 
                reg_list = [list[elem], list[elem+1], list[elem+2], list[elem+3], list[elem+4], list[elem+5]]
                reg_col = [red, green, blue, red, green, blue]
                reg_list_res = [0, 0, 0, 0, 0, 0]
                
                for i in range(6):
                    reg_col[i]  = reg_col[i] * trans
                    reg_col[i]  = reg_col[i] // 255

                for i in range(6):
                    reg_list[i] = reg_list[i] * (255 - trans)
                    reg_list[i] = reg_list[i] // 255

                for i in range(6):
                    reg_list_res[i] = reg_col[i] + reg_list[i]

                result += reg_list_res

            if (red > 0):
                red -= red_step
            if (green > 0):
                green -= green_step
            if (blue > 0):
                blue -= blue_step

        return result


# MAIN PROGRAM
image_list = read_image(IMAGE_PATH)
image_vertical = shader(0, 1, 0, 0, 0, 0, 1, 0, 1, image_list)
save_image(IMAGE_SAVE_PATH, image_vertical)