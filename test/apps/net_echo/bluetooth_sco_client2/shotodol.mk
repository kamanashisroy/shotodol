
# This makefile is parsed by shotodol make module 
# net_echo -send SCO://00:18:E7:37:35:76:00:18:E7:37:27:61 -chunk_size 42 -interval 100 -dryrun yes

all:
	help module
	help fileconf
	module -load ../../../../apps/net_echo/plugin.so
	net_echo -send SCO://00:18:E7:37:35:76:00:18:E7:37:27:61 -chunk_size 48 -interval 100 -dryrun yes
	noconsole

