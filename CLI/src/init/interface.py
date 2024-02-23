from file import *
from collection import *

class InitInterface:
    def __init__(self, term):
        self.term = term
        self.startX, self.startY = self.term.get_location()
        self.term.location(self.startX, self.startY)
        self.length = 0
        self.currentPosY = 0
        self.collection = Collection()

    # Moves Cursor down 
    def down(self):
        if self.currentPosY < self.length:
            self.currentPosY += 1
            y, x = self.term.get_location()
            print(self.term.move_xy(30, y))
        elif self.currentPosY == self.length:
            y, x = self.term.get_location()
            print(self.term.move_xy(0, y - self.length - 1))
            self.currentPosY = 0
    
    # Move Cursor ip
    def up(self):
        if self.currentPosY > 0:
            self.currentPosY -= 1
            y, x = self.term.get_location()
            print(self.term.move_xy(30, y - 2))
        elif self.currentPosY == 0:
            y, x = self.term.get_location()
            print(self.term.move_xy(0, y + self.length - 1))
            self.currentPosY = self.length
    
    # Iterates over the list of files   
    # increases the length of the list backend
    # Adds File objects to a list
    def walk(self, filepath):
        for entry in os.scandir(filepath):
            self.length += 1
            if entry.is_dir():
                file = File(entry.name, filepath, dirCheck=True) 
                self.collection.appendFile(file)
            else:
                file = File(entry.name, filepath)
                self.collection.appendFile(file)

    def select(self):
        file = self.collection.findFileObj(self.currentPosY)
        if file.dir == True and file.expanded == False:
            dirContents = file.expand()
            self.length += len(dirContents)
            self.collection.addDir(dirContents, self.currentPosY)
            file.expanded = True
            file.selected = True
        else:
            file.change()
        # Find the File object at the current location
        # Change to selected
    
    # Deselects files / dir
    def deselect(self):
        file = self.collection.findFileObj(self.currentPosY)
        if file.dir == True and file.expanded == True:
            dirPath = file.filepath + file.filename + "/"
            deleteLength = self.collection.removeDir(dirPath, self.currentPosY)
            # Find a way to reduce the self.collection.fileList
            self.length -= deleteLength
            file.change()
            file.expanded = False                 
        else:
            file.change()
    
    def interact(self):
        if self.collection.findFileObj(self.currentPosY).selected:
            self.deselect()
        else:
            self.select()
        

    # Calls display on Collection
    def display(self, x, y):
        print(self.term.move_xy(x, y))
        self.collection.display(self.term)
        print(self.term.bold("PRESS HERE TO GENERATE JSON..."))
        print(self.term.move_xy(x, y + self.currentPosY))
    # Main Loop (Calls function)
    def mainLoop(self, func):
        func()
        