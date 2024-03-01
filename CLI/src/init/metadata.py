
# TODO: Add name, desc, and dependency checking

# CapsuleObject:
#    Name: u8
#    files: []u8
#    version: []u8
#    desc: []u8
#    dependencies: []u8


class PkgMetaData:
    def __init__(self, files, name, desc, version="0.0.1", dependencies=[]):
        self.name = name
        self.desc = desc
        self.files = files
        self.version = version
        self.dependencies = dependencies
    def addFile(self, file):
        self.files.append(file)
# class DependencyData:
#     def __init__(self, name : str, versionStr : str):
#         self.name = name
#         self.version = versionStr
