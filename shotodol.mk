
# This makefile is parsed by shotodol make module 

all:
	help module
	help fileconf
	fileconf -i ./shotodol.conf
	module -load command/programming/plugin.so


