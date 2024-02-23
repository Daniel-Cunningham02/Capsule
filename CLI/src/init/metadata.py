
# TODO: Add name, desc, and dependency checking

class PkgMetaData:
    def __init__(self, files, name, desc, dependencies=[]):
        self.name = name
        self.desc = desc
        self.files = files
        self.dependencies = dependencies
    def addFile(self, file):
        self.files.append(file)
# class DependencyData:
#     def __init__(self, name : str, versionStr : str):
#         self.name = name
#         self.version = versionStr
