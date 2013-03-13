
include .config.mk
OBJDIR=build/.objects
#OBJECTS=$(wildcard $(OBJDIR)/*.o)
OBJECTS=$(OBJDIR)/Main.o $(OBJDIR)/Module.o $(OBJDIR)/propeller.o $(OBJDIR)/spindle.o $(OBJDIR)/MainTurbine.o
LIBS+=-L$(VALA_HOME)/aroop/core/ -laroop_core
TARGET=shotodol.bin
include build/platform.mk

all:$(TARGET)

$(TARGET):
	$(CC) $(RDYNAMIC) $(OBJECTS) $(LIBS) -o $@

clean:
	$(RM) $(TARGET)
