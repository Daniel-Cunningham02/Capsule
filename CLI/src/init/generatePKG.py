from metadata import *
import json
from createCapsule import *

def makeJSON(metadata : PkgMetaData):
    return json.dumps(metadata, default=lambda o: o.__dict__, sort_keys=True, indent=4)

def extractFileInfo(files : list, name : str, desc : str):
    metadata = PkgMetaData([], name, desc)
    for i in files:
        metadata.addFile((i.filepath + i.filename))
    return metadata

def getJSON(files : list, name : str, desc : str):
    metadata = extractFileInfo(files, name, desc)
    string = makeJSON(metadata)
    return string

def moveTermUp(pos, length, term):
    if pos > 0:
        pos -= 1
        y, x = term.get_location()
        print(term.move_xy(0, y - 2))
    elif pos == 0:
        y, x = term.get_location()
        print(term.move_xy(0, y + length - 2))
        pos = length
    return pos

def moveTermDown(pos, length, term):
    if pos < length:
        pos += 1
        y, x = term.get_location()
        print(term.move_xy(0, y))
    elif pos == length:
        y, x = term.get_location()
        print(term.move_xy(0, y - length - 1))
        pos = 0
    return pos

def generatePKG(files : list, name : str, desc : str, term):
    print("Please select the main file")
    currentPos = 0
    length = 0
    zigFiles = []
    for i in files:
        if (i.filepath + i.filename).endswith(".zig"):
            length += 1
            zigFiles.append(i)
            i.display(term)
    if length < 1:
        print(term.bold("No Zig files selected.\nNo capsule can be made!"))
        exit(1)
    inp = term.inkey(timeout=10)
    while inp != 'q':
        if inp.name == u'KEY_ENTER':
            mainFile = zigFiles[currentPos - 1]
            break
        elif inp.name == u'KEY_UP':
            currentPos = moveTermUp(currentPos, length, term)
        elif inp.name == u'KEY_DOWN':
            currentPos = moveTermDown(currentPos, length, term)
        inp = term.inkey(timeout=10)
    json = getJSON(files, name, desc)
    createCapsule(name)
    filepath = './{}/src'.format(name)
    # Write the files selected to the filepath
