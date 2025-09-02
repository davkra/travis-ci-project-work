cmake_minimum_required(VERSION 3.10)
project(TestProject)

# Set C++ Standard
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Compiler Flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -fPIC")

# Directories
set(LIB_DIR lib)
set(SRC_DIR src)
set(OBJ_DIR obj)
set(INC_DIR inc)

# Output Binaries and Libraries
set(BIN Main)
set(LIBNAME Test)

# Source files (excluding Main.cpp)
file(GLOB SRC_FILES "${SRC_DIR}/*.cpp")
list(REMOVE_ITEM SRC_FILES "${SRC_DIR}/${BIN}.cpp")

# Set shared library target
add_library(${LIBNAME} SHARED ${SRC_FILES})
target_include_directories(${LIBNAME} PRIVATE ${INC_DIR})
set_target_properties(${LIBNAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${LIB_DIR})

# Main executable
add_executable(${BIN} ${SRC_DIR}/${BIN}.cpp)
target_include_directories(${BIN} PRIVATE ${INC_DIR})
target_link_directories(${BIN} PRIVATE ${CMAKE_BINARY_DIR}/${LIB_DIR})
target_link_libraries(${BIN} ${LIBNAME})

# JavaTester
add_custom_target(JAVA_TESTER
    COMMAND ${CMAKE_MAKE_PROGRAM} -C ${CMAKE_SOURCE_DIR}/JavaTester
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/JavaTester
    COMMENT "Building JavaTester"
)

# Add a test target
add_custom_target(test
    COMMAND ${CMAKE_MAKE_PROGRAM} run -C ${CMAKE_SOURCE_DIR}/JavaTester
    COMMENT "Running tests"
)

# Clean-up target
add_custom_target(clean-all
    COMMAND ${CMAKE_MAKE_PROGRAM} clean
    COMMAND rm -rf ${CMAKE_BINARY_DIR}/${LIB_DIR} ${CMAKE_BINARY_DIR}/${OBJ_DIR} ${BIN}
    COMMENT "Cleaning up all build artifacts"
)
