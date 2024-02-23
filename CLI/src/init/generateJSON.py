from metadata import *
import json

def makeJSON(metadata : PkgMetaData):
    return json.dumps(metadata, default=lambda o: o.__dict__, sort_keys=True, indent=4)

def extractFileInfo(files : list):
    metadata = PkgMetaData([])
    for i in files:
        metadata.addFile((i.filepath + i.filename))
    return metadata

def getJSON(files : list):
    metadata = extractFileInfo(files)
    string = makeJSON(metadata)
    return string