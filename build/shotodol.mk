
include .config.mk
OBJDIR=$(SHOTODOL_HOME)/build/.objects
include $(SHOTODOL_HOME)/build/staticlibs.mk
#OBJECTS=$(wildcard $(OBJDIR)/*.o)
#LIBS+=-L$(VALA_HOME)/aroop/core/ -laroop_core
TARGET=shotodol.bin
include $(SHOTODOL_HOME)/build/platform.mk

all:$(TARGET)

$(TARGET):
	$(CC) $(RDYNAMIC) $(OBJECTS) $(LIBS) -o $@

clean:
	$(RM) $(TARGET)
