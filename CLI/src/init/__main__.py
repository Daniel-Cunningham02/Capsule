from interface import *
from blessed import Terminal
from generatePKG import *
from enum import Enum

class Result(Enum):
    Valid = 0
    Invalid = 1
                   
def writeFile(json):
    f = open("module.json", "w")
    f.write(json)
    f.flush()
    f.close()

def checkASCII(name, char):
    if chr(char) in name:
        return Result.Invalid
    return Result.Valid

def checkName(name):
    for i in range(33, 45):
        if(checkASCII(name, i) == Result.Invalid):
           return Result.Invalid
    for i in range(46, 48):
        if(checkASCII(name, i) == Result.Invalid):
            return Result.Invalid
    for i in range(59, 65):
        if(checkASCII(name, i) == Result.Invalid):
            return Result.Invalid
    for i in range(91, 97):
        if(checkASCII(name, i) == Result.Invalid):
            return Result.Invalid
    return Result.Valid

def getPKGDescriptors():
    print("What is the name of the package: ", end='')
    name = input()
    while(checkName(name) == Result.Invalid):
        print("The only special character allowed is -\nGive another name:",
              end = '')
        name = input()
    print("Give a description of the package:")
    desc = input()
    return (name, desc)

def init(interface: InitInterface):
    name, desc = getPKGDescriptors()
    with interface.term.cbreak():
        startY, startX = interface.term.get_location()
        interface.walk("./")
        interface.display(startX, startY)
        inp = None
        inp = interface.term.inkey(timeout=10)
        while inp != 'q':
            (y, x) = interface.term.get_location()
            if inp.name == u'KEY_ENTER':
                if interface.currentPosY == interface.length:
                    generatePKG(
                        interface.collection.getSelectedFiles(),
                        name,
                        desc,
                        interface.term
                    )
                    inp = 'q'
                    break                  
                else:
                    interface.interact()
                    interface.display(0, y - interface.currentPosY - 1)
            elif inp.name == u'KEY_UP':
                interface.up()
            elif inp.name == u'KEY_DOWN':
                interface.down()
            inp = interface.term.inkey(timeout=10)
    print(interface.term.move_xy(0, y + (interface.length - interface.currentPosY)))
                 

if __name__ == "__main__":
    interface = InitInterface(Terminal())
    interface.mainLoop(init(interface))
