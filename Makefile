

AROOPMK=$(MAKE) -f ../../build/aroop.mk

all:

apps:
	$(AROOPMK) -C apps/key_value

base:
	$(AROOPMK) -C core/base
	$(AROOPMK) -C core/io
	$(AROOPMK) -C core/console
