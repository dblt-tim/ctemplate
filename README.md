# C project template

## How to use

the Makefile has 4 rules :
- all : will default to exec
- exec : builds the executable
- clean : deletes the build directory and the executable
- run : builds and runs the executable

## Variables you can change

EXEC : your executable name  
EXEC_OUTPUT : the directory where your executable will go  
SRC_DIR : the source code directory  
BUILD_DIR : the directory where your build files will go  
CC : your compiler  
CFLAGS, CPPFLAGS and LDFLAGS : compilation flags  

> the constants are not meant to be changed !