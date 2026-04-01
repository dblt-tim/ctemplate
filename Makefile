# Makefile
# --- Variables ---

EXEC = exec
LIB = mylib
# note : "lib" and file extension are automatically added to the library output

EXEC_OUTPUT = $(BUILD_DIR)/bin
LIB_OUTPUT = $(BUILD_DIR)/lib
HEADERS_OUTPUT = $(BUILD_DIR)/headers
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

default: run


# --- Constants ---

CFLAGS += -Wall -Wextra -O2 -std=c17 \
    -Wfloat-equal \
    -Wshadow \
    -Wswitch-default \
    -Wreturn-type \
    -fanalyzer \
    -MMD \
    -MP


CFILES = $(shell find $(SRC_DIR) -type f -iname "*.c")
OBJFILES = $(CFILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/obj/%.o)
HFILES = $(shell find $(SRC_DIR) -type f -iname "*.h")
HFILES_OUT = $(HFILES:$(SRC_DIR)/%.h=$(BUILD_DIR)/headers/%.h)

-include $(OBJFILES:.o=.d)

# --- RULES ---

.PHONY: all clean run

exec: $(OBJFILES)
	mkdir -p $(EXEC_OUTPUT)
	$(CC) $(LDFLAGS) $(OBJFILES) -o $(EXEC_OUTPUT)/$(EXEC)
	
$(BUILD_DIR)/obj/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
	
clean:
	@if [ -z "$(BUILD_DIR)" ] || [ "$(BUILD_DIR)" = "." ] || [ "$(BUILD_DIR)" = "/" ]; then \
		read -p "WARNING : BUILD_DIR is '$(BUILD_DIR)', are you sure whatever you are doing is worth it ? (rm -rf $(BUILD_DIR) will be executed) [y/n] " ans; \
		if [ "$$ans" != "y" ] && [ "$$ans" != "Y" ]; then \
			echo "Aborted."; \
			exit 1; \
		fi; \
	fi; \
	rm -rf $(BUILD_DIR)
	
run: exec
	./$(EXEC_OUTPUT)/$(EXEC)

lib: $(OBJFILES)
	mkdir -p $(LIB_OUTPUT)
	ar rcs $(LIB_OUTPUT)/lib$(LIB).a $(OBJFILES)

$(BUILD_DIR)/headers/%.h: $(SRC_DIR)/%.h
	@mkdir -p $(dir $@)
	cp $< $@
	
dylib: $(OBJFILES)
	mkdir -p $(LIB_OUTPUT)
	$(CC) -fPIC -shared $(LDFLAGS) $(OBJFILES) -o $(LIB_OUTPUT)/lib$(LIB).so
	
headers: $(HFILES_OUT)