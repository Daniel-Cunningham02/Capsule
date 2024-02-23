import os

class File:
    def __init__(self, filename, filepath, parent=None, dirCheck=False):
        self.filename = filename
        self.filepath = filepath
        self.dir = dirCheck
        self.expanded = False
        self.selected = False
        self.parent = parent
        self.prefix = ''
        if parent == None:
            self.indentation = 1
        else:
            self.indentation = self.parent.indentation + 1
        # Need to redo parent and indentation system
    def change(self):
        self.selected = not self.selected

    def expand(self):
        contentsList = []
        # Get directory contents
        dirPath = self.filepath + self.filename + "/"
        for entry in os.scandir(dirPath):
            if entry.is_dir():
                contentsList.append(File(entry.name, dirPath, parent=self, dirCheck=True)) 
            else:
                contentsList.append(File(entry.name, dirPath, parent=self))
        return contentsList
    
    def addChild(self, file):
        self.children.append(file)
    
    def display(self, term):
        y, x = term.get_location()
        if self.parent != None:
            self.prefix = '| '
        if self.selected == True:
            print(term.clear_eos + term.move_x(((self.indentation - 1) * 3) + 2) + term.green_underline(self.prefix + self.filename), end='')
            print(term.move_y(y))
        else:
            print(term.clear_eos + term.move_x(((self.indentation - 1) * 3) + 2) + term.red(self.prefix + self.filename), end='')
            print(term.move_y(y))
