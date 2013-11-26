

BUILD=$(MAKE) -f ../../build/build.mk
CLEAN=$(MAKE) -f ../../build/clean.mk
SHOTODOL=$(MAKE) -f build/shotodol.mk

all:makecore makeapps makemain shotodol

makeapps:
	$(BUILD) -C apps/key_value

cleanapps:
	$(CLEAN) -C apps/key_value

makecore:
	$(BUILD) -C libs/iostream
	$(BUILD) -C libs/str_arms
	$(BUILD) -C libs/propeller
	$(BUILD) -C libs/proto_pktizer
	$(BUILD) -C libs/db
	$(BUILD) -C libs/make100
	$(BUILD) -C core/base
	$(BUILD) -C core/io
	$(BUILD) -C core/commands
	$(BUILD) -C core/console
	$(BUILD) -C core/make

cleancore:
	$(CLEAN) -C libs/iostream
	$(CLEAN) -C libs/str_arms
	$(CLEAN) -C libs/propeller
	$(CLEAN) -C libs/proto_pktizer
	$(CLEAN) -C libs/db
	$(CLEAN) -C libs/make100
	$(CLEAN) -C core/base
	$(CLEAN) -C core/io
	$(CLEAN) -C core/commands
	$(CLEAN) -C core/console
	$(CLEAN) -C core/make

makemain:
	$(BUILD) -C main/main

cleanmain:
	$(CLEAN) -C main/main
	$(SHOTODOL) clean

shotodol:
	$(SHOTODOL)

clean:cleancore cleanapps cleanmain
