from interface import *
from blessed import Terminal
from generateJSON import *

def writeFile(json):
    f = open("module.json", "w")
    f.write(json)
    f.flush()
    f.close()

def init(interface: InitInterface):
    with interface.term.cbreak(): # Try to rewrite with cbreak() context manager
        print("\n")
        startY, startX = interface.term.get_location()
        interface.walk("./")
        interface.display(startX, startY - 1)
        inp = None
        inp = interface.term.inkey(timeout=10)
        while inp != 'q':
            (y, x) = interface.term.get_location()
            if inp.name == u'KEY_ENTER':
                if interface.currentPosY == interface.length:
                    writeFile(getJSON(interface.collection.getSelectedFiles()))
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
