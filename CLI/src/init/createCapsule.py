import os
import subprocess
import shlex

def createCapsule(name):
    path = os.path.join("./", name)
    if os.path.exists(path):
        print("[CREATION ERROR]: Directory already exists!")
    else:
        os.mkdir(path)
        os.system("cd {}".format(path))
        os.system("zig init-exe")
        os.system("mv ./src/ ./{}/".format(name))
        os.system("mv ./build.zig ./{}/".format(name))
