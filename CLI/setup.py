import zipfile
import os
filepath = "./src/init"

stringsToRemove = ['from file import *', 'from collection import *',
                   'from generateJSON import *', 'from metadata import *',
                   'from interface import *']

try:
    print("Combining Initialization scripts into a module")
    with zipfile.ZipFile('../../zig-out/bin/initialize.zip', 'w') as zipf:
        for i in os.scandir("./"):
            zipf.write(i.path)
    print("Created module successfully")
except:
    raise Exception("Failed to create module!")
