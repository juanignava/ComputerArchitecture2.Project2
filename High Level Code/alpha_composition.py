# IMPORTS
import numpy as np
import imageio

# CONSTANS
IMAGE_PATH = "Images/dog.jpeg"
IMAGE_SAVE_PATH = "Images/dog_processed.jpeg"
FILE_PATH_READ = "TextFiles/readfile.txt"
IMAGE_SIZE_X = 200
IMAGE_SIZE_Y = 150

# AUXILIAR IMAGE FUNTIONS

def read_image(path):
    array = np.array(imageio.imread(path), dtype='int').tolist()
    print("Beggning array")
    print(array[1])
    list = []
    for y in range(IMAGE_SIZE_Y):
        for x in range(IMAGE_SIZE_X):
            for pix in range(3):
                list.append(array[y][x][pix])
    return list

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
    print("Beggning matrix")
    print(matrix[1])

    return imageio.imwrite(path, np.array(matrix, dtype='uint8'))

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

def vertical_shader(R1, R0, G1, G0, B1, B0, T1, T0, list):
    red = 0
    green = 0
    blue = 0
    trans = 0

    if (R1 and R0):
        red = 255
    elif (R1):
        red = 191
    elif (R0):
        red = 63
    else:
        red = 0

    if (G1 and G0):
        green = 255
    elif (G1):
        green = 191
    elif (G0):
        green = 63
    else:
        green = 0

    if (B1 and B0):
        blue = 255
    elif (B1):
        blue = 191
    elif (B0):
        blue = 63
    else:
        blue = 0

    if (T1 and T0):
        trans = 255
    elif (T1):
        trans = 191
    elif (T0):
        trans = 63
    else:
        trans = 0

    red_step = red / IMAGE_SIZE_Y
    green_step = green / IMAGE_SIZE_Y
    blue_step = blue / IMAGE_SIZE_Y

    result = []

    for y in range(IMAGE_SIZE_Y):
        for x in range(IMAGE_SIZE_X):
            for pix in range(3):
                elem = y * IMAGE_SIZE_X * 3 + x * 3 + pix
                if (pix == 0):
                    color_val = list[elem]
                    red_out = (red * trans) / 255 + (color_val * (255 - trans)) / 255
                    result.append(red_out)
                elif (pix == 1):
                    color_val = list[elem]
                    green_out = (green * trans) / 255 + (color_val * (255 - trans)) / 255
                    result.append(green_out)
                else:
                    color_val = list[elem]
                    blue_out = (blue * trans) / 255 + (color_val * (255 - trans)) / 255
                    result.append(blue_out)
        red -= red_step
        green -= green_step
        blue -= blue_step

    return result


def second_shader(R1, R0, G1, G0, B1, B0, T1, T0, list):
    red = 0
    green = 0
    blue = 0
    trans = 0

    if (R1 and R0):
        red = 255
    elif (R1):
        red = 191
    elif (R0):
        red = 63
    else:
        red = 0

    if (G1 and G0):
        green = 255
    elif (G1):
        green = 191
    elif (G0):
        green = 63
    else:
        green = 0

    if (B1 and B0):
        blue = 255
    elif (B1):
        blue = 191
    elif (B0):
        blue = 63
    else:
        blue = 0

    if (T1 and T0):
        trans = 255
    elif (T1):
        trans = 191
    elif (T0):
        trans = 63
    else:
        trans = 0

    red_p = 0
    green_p = 0
    blue_p = 0
    up = 1

    red_step = 2 * red / IMAGE_SIZE_Y 
    green_step = 2 * green / IMAGE_SIZE_Y
    blue_step = 2 * blue / IMAGE_SIZE_Y

    result = []

    for y in range(IMAGE_SIZE_Y):
        if (y >= IMAGE_SIZE_Y/2):
            up = 0
        if (up):
            red_p += red_step
            green_p += green_step
            blue_p += blue_step
        else:
            red_p -= red_step
            green_p -= green_step
            blue_p -= blue_step
        
        for x in range(IMAGE_SIZE_X):
            for pix in range(3):
                elem = y * IMAGE_SIZE_X * 3 + x * 3 + pix
                if (pix == 0):
                    color_val = list[elem]
                    red_out = (red_p * trans) / 255 + (color_val * (255 - trans)) / 255
                    result.append(red_out)
                elif (pix == 1):
                    color_val = list[elem]
                    green_out = (green_p * trans) / 255 + (color_val * (255 - trans)) / 255
                    result.append(green_out)
                else:
                    color_val = list[elem]
                    blue_out = (blue_p * trans) / 255 + (color_val * (255 - trans)) / 255
                    result.append(blue_out)

        

    return result


# MAIN PROGRAM
image_list = read_image(IMAGE_PATH)
image_vertical = second_shader(1, 1, 1, 0, 0, 0, 1, 0, image_list)
save_image(IMAGE_SAVE_PATH, image_vertical)