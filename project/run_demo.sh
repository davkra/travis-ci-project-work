#!/bin/bash

cd "$(dirname "$0")"

# Build libTest.so
cmake . && make

# Build mvn project javatester
cd javatester
mvn clean package

# Build libmyNativeLibrary.so and run javatester
./01_build.sh
./02_run.sh
