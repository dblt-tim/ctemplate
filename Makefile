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
CFLAGS = -std=c17
CPPFLAGS = 
LDFLAGS = 

.PHONY: default
default: debug


# --- Constants ---

CFLAGS += -Wall -Wextra -O2 \
    -Wfloat-equal \
    -Wshadow \
    -Wswitch-default \
    -Wreturn-type \
    -fanalyzer \
    -MMD \
    -MP


CFILES = $(shell find $(SRC_DIR) -type f -iname "*.c")
RELEASE_OBJS = $(CFILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/release/obj/%.o)
DEBUG_OBJS = $(CFILES:$(SRC_DIR)/%.c=$(BUILD_DIR)/debug/obj/%.o)
HFILES = $(shell find $(SRC_DIR) -type f -iname "*.h")
HFILES_OUT = $(HFILES:$(SRC_DIR)/%.h=$(BUILD_DIR)/headers/%.h)

-include $(OBJFILES:.o=.d)

# --- RULES ---

.PHONY: all clean run lib dylib headers exec debug

all: exec lib dylib headers

exec: $(RELEASE_OBJS)
	mkdir -p $(EXEC_OUTPUT)
	$(CC) $(LDFLAGS) $(RELEASE_OBJS) -o $(EXEC_OUTPUT)/$(EXEC)
	
debug: $(DEBUG_OBJS)
	mkdir -p $(EXEC_OUTPUT)
	$(CC) $(LDFLAGS) -g $(DEBUG_OBJS) -o $(EXEC_OUTPUT)/debug-$(EXEC)
	
$(BUILD_DIR)/release/obj/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@
	
$(BUILD_DIR)/debug/obj/%.o: $(SRC_DIR)/%.c
	mkdir -p $(dir $@)
	$(CC) -g $(CPPFLAGS) $(CFLAGS) -c $< -o $@
	
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

lib: $(RELEASE_OBJS) headers
	mkdir -p $(LIB_OUTPUT)
	ar rcs $(LIB_OUTPUT)/lib$(LIB).a $(RELEASE_OBJS)

$(BUILD_DIR)/headers/%.h: $(SRC_DIR)/%.h
	@mkdir -p $(dir $@)
	cp $< $@
	
dylib: $(RELEASE_OBJS) headers
	mkdir -p $(LIB_OUTPUT)
	$(CC) -fPIC -shared $(LDFLAGS) $(RELEASE_OBJS) -o $(LIB_OUTPUT)/lib$(LIB).so
	
headers: $(HFILES_OUT)

dylib-debug: $(DEBUG_OBJS) headers
	mkdir -p $(LIB_OUTPUT)
	$(CC) -fPIC -shared $(LDFLAGS) $(DEBUG_OBJS) -o $(LIB_OUTPUT)/libdebug-$(LIB).so

lib-debug: $(DEBUG_OBJS) headers
	mkdir -p $(LIB_OUTPUT)
	ar rcs $(LIB_OUTPUT)/libdebug-$(LIB).a $(DEBUG_OBJS)