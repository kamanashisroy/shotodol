include $(MODULE_DEPTH)/build/.config.mk

all:
	$(MAKE) -f $(SHOTODOL_HOME)/build/aroop.mk
	$(MAKE) -f $(SHOTODOL_HOME)/build/c.mk


