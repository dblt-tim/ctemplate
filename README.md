# C project template

## How to use

the Makefile has 4 rules :
- default : defaults to run
- exec : builds the executable
- clean : deletes the build directory and the executable
- run : builds and runs the executable
- lib : builds the library
- dylib : builds the library as a shared object
- headers : copies your headers for packaging

## Variables you can change

EXEC : your executable name  
LIB : your library name  
EXEC_OUTPUT : the directory where your executable will go  
LIB_OUTPUT : same with libraries  
HEADERS_OUTPUT : same with headers  
SRC_DIR : the source code directory  
BUILD_DIR : the directory where your build files will go  
CC : your compiler  
CFLAGS, CPPFLAGS and LDFLAGS : compilation flags  
default : the default rule to make

> the constants are not meant to be changed !