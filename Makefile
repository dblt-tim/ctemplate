# Makefile
# --- Variables ---

EXEC = exec

EXEC_OUTPUT = $(BUILD_DIR)/bin
# set output to . for project root

# directories
SRC_DIR = source
BUILD_DIR = build

# compiler
CC = gcc

# compilation flags
CFLAGS = 
CPPFLAGS = 
LDFLAGS = 


# --- Constants ---

CFLAGS += -Wall -Wextra -O2 -std=c17 \
    -Wfloat-equal \
    -Wshadow \
    -Wswitch-default \
    -Wreturn-type \
    -fanalyzer

CFILES = $(shell find $(SRC_DIR) -type f -iname "*.c")
OBJFILES = $(CFILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/obj/%.o)

# --- RULES ---

.PHONY: all clean run

all: exec

exec: $(OBJFILES)
	mkdir -p $(EXEC_OUTPUT)
	$(CC) $(LDFLAGS) $(OBJFILES) -o $(EXEC_OUTPUT)/$(EXEC)
	
$(BUILD_DIR)/obj/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	gcc $(CFLAGS) -c $< -o $@
	
clean:
	rm -rf $(BUILD_DIR) $(EXEC_OUTPUT)/$(EXEC)
	
run: exec
	./$(EXEC_OUTPUT)/$(EXEC)