#!/bin/bash

# Not really comfortable with the zig build
# system atm so I'll use this script for now.

mkdir build
cd build
zig build-exe ../src/main.zig -lc -lraylib && ./main
# zig build-exe ../src/main.zig -lc -lraylib
