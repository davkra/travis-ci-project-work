#!/bin/bash
cd "$(dirname "$0")"
cd src/main/java

# Configure library paths
export LD_LIBRARY_PATH=../../../../javatester/src/main/java/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=../../../../lib:$LD_LIBRARY_PATH

# Run the Main class MyNativeClass
java -cp ../../../target/javatester-1.0-SNAPSHOT.jar at.libtester.MyNativeClass
