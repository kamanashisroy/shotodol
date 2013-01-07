
include ../../.config.mk
OBJDIR=../../build/.objects
VSOURCES=$(wildcard vsrc/*.vala)
VSOURCE_BASE=$(basename $(notdir $(VSOURCES)))
CSOURCES=$(addprefix vsrc/, $(addsuffix .c,$(VSOURCE_BASE)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))

INCLUDES+=-I$(VALA_HOME)/aroop/core/inc
LIBS+=-L$(VALA_HOME)/aroop/core/ -laroop_core
include includes.mk


all:objects

objects:preobjects $(OBJECTS)

preobjects:
	mkdir -p $(OBJDIR)/

$(OBJDIR)/%.o:vsrc/%.c
	$(CC) $(CFLAGS) -c $(INCLUDES) $< -o $@


