# binary => string
def twoComplement(binary):

    aux = ""

    for i in binary:
        if(i == "0"):
            aux += "1"
        
        else:
            aux += "0"

    aux = int(aux, 2)
    aux += 1
    aux = bin(aux).replace("0b", "")
    return aux

# number => int
# instructionType => string
# opcode => string
# pointerLine => int
def signExtension(number, instructionType, opcode, pointerLine):

    # control instruction
    if(instructionType == "00"):
        immediate = number - pointerLine

    # memory or data instruction
    else:
        immediate = number

    binary = bin(abs(immediate)).replace("0b", "")
    binaryLength = len(binary)

    # control instruction
    if(instructionType == "00"):
        conditional = opcode[2]
        #print("El opCode es: " + str(opcode))
        #print("El condicional es: " + str(conditional))

        # conditional instruction
        if(conditional == "0"):
            extension = "0" * (18 - binaryLength)
            binary = extension + binary

            # PC - direction
            if(immediate < 0):
                binary =  twoComplement(binary)
            return binary
            
        # unconditional instruction
        else:
            extension = "0" * (26 - binaryLength)
            binary = extension + binary

            # PC - direction
            if(immediate < 0):
                binary =  twoComplement(binary)

            return binary            

    # memory instruction
    elif(instructionType == "01"):
        extension = "0" * (18 - binaryLength)
        binary = extension + binary

        # PC - direction
        if(immediate < 0):
            binary =  twoComplement(binary)

        return binary 

    # data instruction
    else:
        flagImmediate = opcode[2]

        # immediate
        if(flagImmediate == "1"):
            extension = "0" * (18 - binaryLength)
            binary = extension + binary

            # PC - direction
            if(immediate < 0):
                binary =  twoComplement(binary)

            return binary

# case 0: control risks
# instructionElements => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def stallInsertionCase0(instructionElements, typeDictionary):

    result = instructionElements.copy()

    # this insertion avoids index out of range error
    result.append("*")
    stall = ['SUM', 'R0', 'R0', 'R0', "********************"]
    i = 0

    # loop to iterate each instruction
    for j in result:
        if(len(j) > 1):

            currentInstruction = j[0]
            currentInstructionType = typeDictionary[currentInstruction]

            # control instruction
            if(currentInstructionType == "00"):
                result.insert(i + 1, stall)
                result.insert(i + 2, stall)
                result.insert(i + 3, stall)
                result.insert(i + 4, stall)           
        i += 1

    return result

# case 1: dependencies between instructions with 0 instructions among them
# instructionElements => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def stallInsertionCase1(instructionElements, typeDictionary, opcodeDictionary):

    result = instructionElements.copy()

    # this insertion avoids index out of range error
    result.append("*")
    stall = ['SUM', 'R0', 'R0', 'R0', "********************"]
    i = 0

    # loop to iterate each instruction
    for j in result:
        if(len(j) > 1):

            if(result[i + 1] == "*"):
                break

            currentInstruction = j[0]
            print("The current instruction is: " + currentInstruction)
            currentInstructionType = typeDictionary[currentInstruction]
            currentDestiny = j[1]

            if(currentDestiny != "R0"):

                # instruction
                if(len(result[i + 1]) > 1):
                    nextInstructionElements = result[i + 1]

                # label
                else:
                    nextInstructionElements = result[i + 2]

                nextInstruction = nextInstructionElements[0]
                nextInstructionType = typeDictionary[nextInstruction]           

                # memory instruction
                if(currentInstructionType == "01" and (currentInstruction == "CRG" or currentInstruction == "CRGV")):

                    # control instruction
                    if(nextInstructionType == "00"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextBranch = nextOpcode[2]

                        # conditional instruction
                        if(nextBranch == "0"):
                            nextSource1 = nextInstructionElements[1]
                            nextSource2 = nextInstructionElements[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                                result.insert(i + 5, stall)

                    # memory instruction
                    elif(nextInstructionType == "01"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextIns = nextOpcode

                        print("Next mem instruction is: " + nextIns)
                        
                        # GRD and GRDV instructions
                        if(nextIns == "00"):
                            nextSource = nextInstructionElements[1]
                            nextDestiny = nextInstructionElements[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                                result.insert(i + 5, stall)
                        
                        # CRG instruction
                        else:
                            nextSource = nextInstructionElements[3]

                            if(currentDestiny == nextSource):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                                result.insert(i + 5, stall)

                    # data instruction
                    else:
                        nextSource2 = nextInstructionElements[2]
                        nextSource3 = nextInstructionElements[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):
                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)
                            result.insert(i + 3, stall)
                            result.insert(i + 4, stall)
                            result.insert(i + 5, stall)

                # data instruction
                else:
                    
                    # control instruction
                    if(nextInstructionType == "00"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextBranch = nextOpcode[2]

                        # conditional instruction
                        if(nextBranch == "0"):
                            nextSource1 = nextInstructionElements[1]
                            nextSource2 = nextInstructionElements[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                        
                    # memory instruction
                    elif(nextInstructionType == "01"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextIns = nextOpcode
                        
                        # GRD or GRDV instruction
                        if(nextIns == "00"):
                            nextSource = nextInstructionElements[1]
                            nextDestiny = nextInstructionElements[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                                result.insert(i + 5, stall)
                        
                        # CRG instruction
                        else:
                            nextSource = nextInstructionElements[3]

                            if(currentDestiny == nextSource):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                                result.insert(i + 5, stall)

                    # data instruction
                    else:
                        nextSource2 = nextInstructionElements[2]
                        nextSource3 = nextInstructionElements[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):
                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)
                            result.insert(i + 3, stall)
                        
        i += 1

    return result[:-1]

# case 2: dependencies between instructions with 1 instruction among them
# instructionElements => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def stallInsertionCase2(instructionElements, typeDictionary, opcodeDictionary):

    result = instructionElements.copy()

    # this insertion avoids index out of range error
    result.append("*")
    stall = ['SUM', 'R0', 'R0', 'R0', "********************"]
    i = 0

    # loop to iterate each instruction
    for j in result:

        if(len(j) > 1):

            if(result[i + 2] == "*"):
                break

            currentInstruction = j[0]
            currentInstructionType = typeDictionary[currentInstruction]
            currentDestiny = j[1]

            if(currentDestiny != "R0"):

                # instruction
                if(len(result[i + 2]) > 1):
                    nextInstructionElements = result[i + 2]

                # label
                else:
                    nextInstructionElements = result[i + 3]

                nextInstruction = nextInstructionElements[0]
                nextInstructionType = typeDictionary[nextInstruction]           
                    
                # memory instruction
                if(currentInstructionType == "01" and (currentInstruction == "CRG" or currentInstruction == "CRGV")):            
                    
                    # control instruction
                    if(nextInstructionType == "00"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextBranch = nextOpcode[2]

                        # conditional instruction
                        if(nextBranch == "0"):
                            nextSource1 = nextInstructionElements[1]
                            nextSource2 = nextInstructionElements[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)

                    # memory instruction
                    elif(nextInstructionType == "01"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextIns = nextOpcode
                        
                        # GRD or GRDV instruction
                        if(nextIns == "00"):
                            nextSource = nextInstructionElements[1]
                            nextDestiny = nextInstructionElements[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                        
                        # CRG or CRGV instruction
                        else:
                            nextSource = nextInstructionElements[3]

                            if(currentDestiny == nextSource):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                                        
                    # data instruction
                    else:
                        nextSource2 = nextInstructionElements[2]
                        nextSource3 = nextInstructionElements[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):
                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)
                            result.insert(i + 3, stall)
                            result.insert(i + 4, stall)

                # data instruction
                else:
                    
                    # control instruction
                    if(nextInstructionType == "00"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextBranch = nextOpcode[2]

                        # conditional instruction
                        if(nextBranch == "0"):
                            nextSource1 = nextInstructionElements[1]
                            nextSource2 = nextInstructionElements[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)

                    # memory instruction
                    elif(nextInstructionType == "01"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextIns = nextOpcode
                        
                        # GRD or GRDV instruction
                        if(nextIns == "00"):
                            nextSource = nextInstructionElements[1]
                            nextDestiny = nextInstructionElements[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)
                        
                        # CRG or CRGV instruction
                        else:
                            nextSource = nextInstructionElements[3]

                            if(currentDestiny == nextSource):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                                result.insert(i + 4, stall)

                    # data instruction
                    else:
                        nextSource2 = nextInstructionElements[2]
                        nextSource3 = nextInstructionElements[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):
                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)

        i += 1

    return result[:-1]

# case 3: dependencies between instructions with 2 instructions among them
# instructionElements => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def stallInsertionCase3(instructionElements, typeDictionary, opcodeDictionary):

    result = instructionElements.copy()

    # this insertion avoids index out of range error
    result.append("*")
    stall = ['SUM', 'R0', 'R0', 'R0', "********************"]
    i = 0

    # loop to iterate each instruction
    for j in result:

        if(len(j) > 1):

            if(result[i + 3] == "*"):
                break

            currentInstruction = j[0]
            currentInstructionType = typeDictionary[currentInstruction]
            currentDestiny = j[1]

            if(currentDestiny != "R0"):

                # instruction
                if(len(result[i + 3]) > 1):
                    nextInstructionElements = result[i + 3]

                # label
                else:
                    nextInstructionElements = result[i + 4]

                nextInstruction = nextInstructionElements[0]
                nextInstructionType = typeDictionary[nextInstruction]           
                    
                # memory instruction
                if(currentInstructionType == "01" and (currentInstruction == "CRG" or currentInstruction == "CRGV")):            
                
                    # control instruction
                    if(nextInstructionType == "00"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextBranch = nextOpcode[2]

                        # conditional instruction
                        if(nextBranch == "0"):
                            nextSource1 = nextInstructionElements[1]
                            nextSource2 = nextInstructionElements[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                    
                    # memory instruction
                    elif(nextInstructionType == "01"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextIns = nextOpcode
                        
                        # GRD or GRDV instruction
                        if(nextIns == "00"):
                            nextSource = nextInstructionElements[1]
                            nextDestiny = nextInstructionElements[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                        
                        # CRG or CRGV instruction
                        else:
                            nextSource = nextInstructionElements[3]

                            if(currentDestiny == nextSource):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)

                    # data instruction
                    else:
                        nextSource2 = nextInstructionElements[2]
                        nextSource3 = nextInstructionElements[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):
                            result.insert(i + 1, stall)
                            result.insert(i + 2, stall)
                            result.insert(i + 3, stall)

                # data instruction
                else:
                    
                    # control instruction
                    if(nextInstructionType == "00"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextBranch = nextOpcode[2]

                        # conditional instruction
                        if(nextBranch == "0"):
                            nextSource1 = nextInstructionElements[1]
                            nextSource2 = nextInstructionElements[2]

                            if(currentDestiny == nextSource1 or currentDestiny == nextSource2):
                                result.insert(i + 1, stall)

                    # memory instruction
                    elif(nextInstructionType == "01"):
                        nextOpcode = opcodeDictionary[nextInstruction]
                        nextIns = nextOpcode
                        
                        # GRD or GRDV instruction
                        if(nextIns == "00"):
                            nextSource = nextInstructionElements[1]
                            nextDestiny = nextInstructionElements[3]

                            if(currentDestiny == nextSource or currentDestiny == nextDestiny):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)
                        
                        # CRG or CRGV instruction
                        else:
                            nextSource = nextInstructionElements[3]

                            if(currentDestiny == nextSource):
                                result.insert(i + 1, stall)
                                result.insert(i + 2, stall)
                                result.insert(i + 3, stall)

                    # data instruction
                    else:
                        nextSource2 = nextInstructionElements[2]
                        nextSource3 = nextInstructionElements[3]

                        if(currentDestiny == nextSource2 or currentDestiny == nextSource3):
                            result.insert(i + 1, stall)

        i += 1

    return result[:-1]

# instructionElements => string list
# typeDictionary => string dictionary
# opcodeDictionary => string dictionary
def riskControlUnit(instructionElements, typeDictionary, opcodeDictionary):

    case0 = stallInsertionCase0(instructionElements, typeDictionary)
    case1 = stallInsertionCase1(case0, typeDictionary, opcodeDictionary)
    case2 = stallInsertionCase2(case1, typeDictionary, opcodeDictionary)
    case3 = stallInsertionCase3(case2, typeDictionary, opcodeDictionary)    

    return case3

def getInstructionElements(filename):

    # open code.txt file for reading
    codeFile = open(filename, 'r')
    codeLines = codeFile.readlines()

    # variable to store all the instruction elements
    instructionElements = []

    # loop to iterate the code file line by line
    for line in codeLines:
        
        # variable to know if the current instruction is a memory one (type 01)
        memoryFlag = 0   
        elements = []
        temp = ""

        # slicing the current line to get the last element

        aux = line[-2]

        # current line contains a label
        if(aux == ":"):
            instructionElements.append([line[:-2]])

        # current line contains an instruction
        else:

            #pointerLine += 1

            # loop to iterate the current line char by char
            for char in line:

                if(char == " " or char == "," or char == "(" or char == ")"):

                    # check if the current instruction is a memory one to change the flag
                    if(char == "("):
                        memoryFlag = 1

                    if(temp != ""):
                        elements.append(temp)

                    temp = ""            

                else:
                    temp += char

            # slice \n from the last element
            temp = temp[:-1]
            elements.append(temp)    
            
            # remove last element if the current instruction is a memory one
            if(memoryFlag == 1):
                elements.pop()

            instructionElements.append(elements)
            
    return instructionElements

# instructionElements => string list list
def getLabelDictionary(instructionElements):
    
    labelDictionary = {}

    # variable to know the number of the current line
    pointerLine = 0

    for instruction in instructionElements:
        pointerLine += 1
        instructionLength = len(instruction)

        # label
        if(instructionLength == 1):
            labelDictionary[instruction[0]] = pointerLine
            instructionElements.remove(instruction)

    return labelDictionary, instructionElements

# instructionElements => string list list
def binaryInstructions(filename, instructionElements, typeDictionary, opcodeDictionary, registerDictionary, labelDictionary):

    # open binaryCode.txt file for writing
    binaryCodeFile = open(filename, 'w')

    # variable to know the number of the current line
    pointerLine = 0

    for elements in instructionElements:

        pointerLine += 1
        print("elements = ", elements)
            
        instructionType = typeDictionary[elements[0]]
        opcode = opcodeDictionary[elements[0]]

        fillingMemory = "00"
        fillingData = "0000000000000"

        # control instruction
        if(instructionType == "00"):
            
            conditional = opcode[2]

            # conditional instruction
            if(conditional == "0"):

                register1 = registerDictionary[elements[1]]
                register2 = registerDictionary[elements[2]]

                direction = elements[3]
                direction = labelDictionary[direction]
                direction = signExtension(direction, instructionType, opcode, pointerLine)

                instruction = instructionType + opcode + register1 + register2 + direction

                print(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + direction)

            # unconditional instruction
            else:
                direction = elements[1]
                direction = labelDictionary[direction]
                direction = signExtension(direction, instructionType, opcode, pointerLine)

                instruction = instructionType + opcode + direction

                print(instructionType + " " + opcode + " " + direction)

        # memory instruction
        elif(instructionType == "01"):

            register1 = registerDictionary[elements[1]]

            immediate = int(elements[2])
            immediate = signExtension(immediate, instructionType, opcode, pointerLine)

            register2 = registerDictionary[elements[3]]       
       
            if (elements[0] == "CRGV" or elements[0] == "GRDV"):
                fillingMemory = "01"
            else:
                fillingMemory = "00"
            
            instruction = instructionType + opcode + fillingMemory + register1 + register2 + (immediate)

            print(instructionType + " " + opcode + " " + fillingMemory + " " + register1 + " " + register2 + " " + immediate)

        # data instruction
        else:

            flagImmediate = opcode[2]

            # immediate
            if(flagImmediate == "1"):

                register1 = registerDictionary[elements[1]]
                register2 = registerDictionary[elements[2]]
                
                immediate = int(elements[3])
    
                immediate = signExtension(immediate, instructionType, opcode, pointerLine)

                instruction = instructionType + opcode + register1 + register2 + immediate

                print(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + immediate)

            # no immediate
            else:

                register1 = registerDictionary[elements[1]]
                register2 = registerDictionary[elements[2]]
                register3 = registerDictionary[elements[3]]

                fillingData += "0"

                instruction = instructionType + opcode + register1 + register2 + register3 + fillingData

                print(instructionType + " " + opcode + " " + register1 + " " + register2 + " " + register3 + " " + fillingData)
        
        print(" ")

        binaryCodeFile.write(instruction + "\n")

    return instructionElements

# type dictionary definition
typeDictionary = {
    "SCI": "00",
    "SCD": "00",
    "SI": "00",

    "GRD": "01",
    "CRG": "01",
    "GRDV": "01",
    "CRGV": "01",


    "SUM": "10",
    "RES": "10",
    "MULEV": "10",
    "DIVEV": "10",
    "SUMV": "10",
    
    "SUMI": "10",
    "RESI": "10",
    "MULI": "10",
    "DIVI": "10"
}

# opcode dictionary definition
opcodeDictionary = {
    "SCI": "0000",
    "SCD": "0100",
    "SI": "0010",

    "GRD": "00",
    "CRG": "01",
    "GRDV": "00",
    "CRGV": "01",

    "SUM": "0000",
    "RES": "0100",
    "MULEV": "0001",
    "DIVEV": "0101",
    "SUMV": "1001",
    
    "SUMI": "0010",
    "RESI": "0110",
    "MULI": "1010",
    "DIVI": "1110"
}

# register dictionary definition
registerDictionary = {
    "R0": "0000",
    "R1": "0001",
    "R2": "0010",
    "R3": "0011",
    "R4": "0100",
    "R5": "0101",
    "R6": "0110",
    "R7": "0111",
    "R8": "1000",
    "R9": "1001",
    "R10": "1010",
    "R11": "1011",
    "R12": "1100",
    "R13": "1101",
    "R14": "1110",
    "R15": "1111",

    "RV0": "0000",
    "RV1": "0001",
    "RV2": "0010",
    "RV3": "0011",
    "RV4": "0100",
    "RV5": "0101",
    "RV6": "0110",
    "RV7": "0111",	
}

instructionElements = getInstructionElements('TextFiles/code_asm.txt')

instructionElements = riskControlUnit(instructionElements, typeDictionary, opcodeDictionary)

#print ("_______")
#print (instructionElements)
#print ("_______")

labelDictionary, instructionElements = getLabelDictionary(instructionElements)

instructionElements.pop()
print(instructionElements)

binaryInstructions('TextFiles/instructions.txt', instructionElements, typeDictionary, opcodeDictionary, registerDictionary, labelDictionary)
