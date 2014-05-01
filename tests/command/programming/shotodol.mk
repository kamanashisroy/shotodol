
# This makefile is parsed by shotodol make module 

all:
	module -load ../../../command/programming/plugin.so
	set -var x -val 1
	if $(x) echo I have $(x) dollar.


