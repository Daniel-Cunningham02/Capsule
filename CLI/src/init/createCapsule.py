import os
import subprocess
import shlex

def createCapsule(name):
    path = os.path.join("./name", name)
    os.mkdir(path)
    subprocess.run(shlex.split("cd {}".format(path)))
    subprocess.run(shlex.split("zig init-exe"))
    subprocess.run(shlex.split("cd ../"))
