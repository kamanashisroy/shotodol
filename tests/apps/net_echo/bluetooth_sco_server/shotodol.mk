
# This makefile is parsed by shotodol make module 

all:
	help module
	help fileconf
	module -load ../../../../apps/net_echo/plugin.so
	net_echo -echo SCO://10:40:F3:9E:D8:97 -dryrun yes -interval 100
	noconsole

