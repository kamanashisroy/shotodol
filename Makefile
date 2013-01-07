

AROOPMK=$(MAKE) -f ../../build/aroop.mk

all:makecore makeapps makemain

makeapps:
	$(AROOPMK) -C apps/key_value

cleanapps:
	$(AROOPMK) -C apps/key_value clean

makecore:
	$(AROOPMK) -C core/base
	$(AROOPMK) -C core/io
	$(AROOPMK) -C core/console
	$(AROOPMK) -C core/commands

cleancore:
	$(AROOPMK) -C core/base clean
	$(AROOPMK) -C core/io clean
	$(AROOPMK) -C core/console clean
	$(AROOPMK) -C core/commands clean

makemain:
	$(AROOPMK) -C main/main

cleanmain:
	$(AROOPMK) -C main/main clean

clean:cleancore cleanapps cleanmain
