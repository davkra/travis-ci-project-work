CC := g++
CFLAGS := -Wall -g -std=c++11

BIN := Main
LIBNAME := Test

LIB_DIR := lib
SRC_DIR := src
OBJ_DIR := obj

LIB := $(LIB_DIR)/lib$(LIBNAME).so

SRC := $(filter-out $(SRC_DIR)/$(BIN).cpp, $(wildcard $(SRC_DIR)/*.cpp))
OBJ := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRC))

all: $(LIB) $(BIN) JAVA_TESTER

$(LIB): $(OBJ)
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -shared -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -Iinc -fPIC -c -o $@ $<

$(BIN): $(OBJ_DIR)/$(BIN).o
	$(CC) $(CFLAGS) -o $@ $< -L$(LIB_DIR) -l$(LIBNAME)

$(OBJ_DIR)/$(BIN).o: $(SRC_DIR)/$(BIN).cpp
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -Iinc -c -o $@ $<

JAVA_TESTER:
	make -C ./JavaTester

test:
	make run -C ./JavaTester

rebuild: clean all

run: all
	@env LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(LIB_DIR) ./$(BIN)

valgrind: all
	valgrind --trace-children=yes env LD_LIBRARY_PATH=$(LD_LIBRARY_PATH):$(LIB_DIR) ./$(BIN) --leak-check=full

.PHONY: clean

clean:
	rm -rf *.so *.o $(BIN) $(LIB_DIR)/ $(OBJ_DIR)/
