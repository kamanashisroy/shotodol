-include build/.config.mk

BUILD=$(MAKE) -f $(SHOTODOL_HOME)/build/build.mk
CLEAN=$(MAKE) -f $(SHOTODOL_HOME)/build/clean.mk
SHOTODOL=$(MAKE) -f $(SHOTODOL_HOME)/build/shotodol.mk

all:.config.mk

cleanshotodol:
	$(SHOTODOL) clean

makeshotodol:
	$(SHOTODOL)

.config.mk:
	lua configure.lua
	include .config.mk
	echo $(SHOTODOL_HOME)

clean:cleanshotodol
