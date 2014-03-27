
# This makefile is parsed by shotodol make module 

all:
	help module
	help fileconf
	module -load ../../../../apps/net_echo/plugin.so
	net_echo -send SCO://00:11:67:82:EB:14:10:40:F3:9E:D8:97 -chunk_size 48 -interval 100 -dryrun yes -reconnect yes
	noconsole

