#!/bin/bash

mkdir $1
cd ./$1
zig init-exe
cd ../
