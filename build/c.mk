
include ../../.config.mk
OBJDIR=../../build/.objects
VSOURCES=$(wildcard vsrc/*.vala)
VSOURCE_BASE=$(basename $(notdir $(VSOURCES)))
CSOURCES=$(addprefix vsrc/, $(addsuffix .c,$(VSOURCE_BASE)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))
PLUGIN=./plugin.so

INCLUDES+=-I$(VALA_HOME)/aroop/core/inc
LIBS+=-L$(VALA_HOME)/aroop/core/ -laroop_core
include ../../build/platform.mk
include includes.mk

# use -fPIC when building shared object
CFLAGS+=-fPIC

all:objects $(PLUGIN)

objects:preobjects $(OBJECTS)

preobjects:
	mkdir -p $(OBJDIR)/

$(OBJDIR)/%.o:vsrc/%.c
	$(CC) $(CFLAGS) -c $(INCLUDES) $< -o $@

$(PLUGIN): objects
	$(CC) --shared -o $(PLUGIN) $(LIBS) $(OBJECTS)

clean:pluginclean objectclean

pluginclean:
	$(RM) $(PLUGIN)

objectclean:
	$(RM) $(OBJDIR)/*.o
	
