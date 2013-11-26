
include .config.mk
OBJDIR=$(SHOTODOL_HOME)/build/.objects
#OBJECTS=$(wildcard $(OBJDIR)/*.o)
OBJECTS=$(OBJDIR)/Main.o $(OBJDIR)/Module.o $(OBJDIR)/propeller.o $(OBJDIR)/spindle.o
OBJECTS+=$(OBJDIR)/MainTurbine.o
OBJECTS+=$(OBJDIR)/StandardIO.o
OBJECTS+=$(OBJDIR)/BrainEngine.o
OBJECTS+=$(OBJDIR)/M100CommandOption.o
OBJECTS+=$(VALA_HOME)/aroop/core/libaroop_core.o
#LIBS+=-L$(VALA_HOME)/aroop/core/ -laroop_core
TARGET=shotodol.bin
include $(SHOTODOL_HOME)/build/platform.mk
include $(PROJECT_HOME)/build/staticlibs.mk

all:$(TARGET)

$(TARGET):
	$(CC) $(RDYNAMIC) $(OBJECTS) $(LIBS) -o $@

clean:
	$(RM) $(TARGET)
