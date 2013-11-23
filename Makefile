

BUILD=$(MAKE) -f ../../build/build.mk
CLEAN=$(MAKE) -f ../../build/clean.mk
SHOTODOL=$(MAKE) -f build/shotodol.mk

all:makecore makeapps makeresources makemain shotodol

makeapps:
	$(BUILD) -C apps/key_value
	$(BUILD) -C apps/avrprogrammer

cleanapps:
	$(CLEAN) -C apps/key_value
	$(CLEAN) -C apps/avrprogrammer

makeresources:
	$(BUILD) -C resources/db

cleanresources:
	$(CLEAN) -C resources/db

makecore:
	$(BUILD) -C libs/iostream
	$(BUILD) -C libs/str_arms
	$(BUILD) -C libs/propeller
	$(BUILD) -C libs/proto_pktizer
	$(BUILD) -C libs/db
	$(BUILD) -C core/base
	$(BUILD) -C core/io
	$(BUILD) -C core/commands
	$(BUILD) -C core/console
	$(BUILD) -C core/rules

cleancore:
	$(CLEAN) -C libs/iostream
	$(CLEAN) -C libs/str_arms
	$(CLEAN) -C libs/propeller
	$(CLEAN) -C libs/proto_pktizer
	$(CLEAN) -C libs/db
	$(CLEAN) -C core/base
	$(CLEAN) -C core/io
	$(CLEAN) -C core/commands
	$(CLEAN) -C core/console
	$(CLEAN) -C core/rules

makemain:
	$(BUILD) -C main/main

cleanmain:
	$(CLEAN) -C main/main
	$(SHOTODOL) clean

shotodol:
	$(SHOTODOL)

clean:cleancore cleanapps cleanresources cleanmain
