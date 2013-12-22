
include .config.mk
BUILD=$(MAKE) -f ../../build/build.mk
CLEAN=$(MAKE) -f ../../build/clean.mk
SHOTODOL=$(MAKE) -f build/shotodol.mk


all:makecore makemain shotodol

makecore:
	$(BUILD) -C libs/iostream
	$(BUILD) -C libs/unittest
	$(BUILD) -C libs/watchdog
	$(BUILD) -C libs/module
	$(BUILD) -C libs/config
	$(BUILD) -C $(PLATFORM)/platform_extra
	$(BUILD) -C libs/str_arms
	$(BUILD) -C libs/propeller
	$(BUILD) -C libs/bundle
	$(BUILD) -C libs/db
	$(BUILD) -C libs/make100
	$(BUILD) -C $(PLATFORM)/platform_net
	$(BUILD) -C libs/netio
	$(BUILD) -C core/base
	$(BUILD) -C core/test
	$(BUILD) -C core/commands
	$(BUILD) -C core/fileconfig
	$(BUILD) -C core/console
	$(BUILD) -C core/make
	$(BUILD) -C libs/turbine

cleancore:
	$(CLEAN) -C libs/iostream
	$(CLEAN) -C libs/unittest
	$(CLEAN) -C libs/watchdog
	$(CLEAN) -C libs/module
	$(CLEAN) -C libs/config
	$(CLEAN) -C $(PLATFORM)/platform_extra
	$(CLEAN) -C libs/str_arms
	$(CLEAN) -C libs/propeller
	$(CLEAN) -C libs/bundle
	$(CLEAN) -C libs/db
	$(CLEAN) -C libs/make100
	$(CLEAN) -C $(PLATFORM)/platform_net
	$(CLEAN) -C libs/netio
	$(CLEAN) -C core/base
	$(CLEAN) -C core/test
	$(CLEAN) -C core/commands
	$(CLEAN) -C core/fileconfig
	$(CLEAN) -C core/console
	$(CLEAN) -C core/make
	$(CLEAN) -C libs/turbine

makemain:
	$(BUILD) -C main/main

cleanmain:
	$(CLEAN) -C main/main
	$(SHOTODOL) clean

shotodol:
	$(SHOTODOL)

clean:cleancore cleanmain
