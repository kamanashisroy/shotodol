

BUILD=$(MAKE) -f ../../build/build.mk
CLEAN=$(MAKE) -f ../../build/clean.mk
SHOTODOL=$(MAKE) -f build/shotodol.mk

all:makecore makeapps makemain shotodol

makeapps:
	$(BUILD) -C apps/key_value

cleanapps:
	$(CLEAN) -C apps/key_value

makecore:
	$(BUILD) -C libs/propeller
	$(BUILD) -C core/base
	$(BUILD) -C core/io
	$(BUILD) -C core/console
	$(BUILD) -C core/commands
	$(BUILD) -C core/rules

cleancore:
	$(CLEAN) -C libs/propeller
	$(CLEAN) -C core/base
	$(CLEAN) -C core/io
	$(CLEAN) -C core/console
	$(CLEAN) -C core/commands
	$(CLEAN) -C core/rules

makemain:
	$(BUILD) -C main/main

cleanmain:
	$(CLEAN) -C main/main
	$(SHOTODOL) clean

shotodol:
	$(SHOTODOL)

clean:cleancore cleanapps cleanmain
