from file import *
# Collects all files and contains methods to
# easily modify the file list
class Collection:
    def __init__(self):
        self.fileList = []

    # Removes contents of the dir from the fileList
    def removeDir(self, dirPath, currentPos):
        length = 0
        for _ in os.scandir(dirPath):
            length += 1
        firstSlice = self.fileList[:currentPos + 1]
        secondSlice = self.fileList[currentPos + 1 + length:]
        self.fileList = firstSlice + secondSlice
        return length    
    # Adds contents of a dir to the fileList to display
    def addDir(self, files, pos):
        beginSlice = self.fileList[0:(pos + 1)]
        endSlice = self.fileList[(pos + 1):]
        self.fileList = beginSlice + files + endSlice
    
    def getSelectedFiles(self):
        selectedFiles = []
        for i in self.fileList:
            if i.selected == True:
                selectedFiles.append(i)
        return selectedFiles
    
    # Appends file to the end of the fileList
    def appendFile(self, file):
        self.fileList.append(file)

    # Find File Object at currentPosY    
    def findFileObj(self, pos):
        return self.fileList[pos]
    
    # Calls display on every file in fileList
    def display(self, term):
        for i in self.fileList:
            i.display(term)   
