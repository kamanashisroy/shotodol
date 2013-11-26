
include ../../.config.mk
OBJDIR=$(PROJECT_HOME)/build/.objects
VSOURCES=$(wildcard vsrc/*.vala)
VSOURCE_BASE=$(basename $(notdir $(VSOURCES)))
CSOURCES=$(addprefix vsrc/, $(addsuffix .c,$(VSOURCE_BASE)))
OBJECTS=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(VSOURCE_BASE)))
PLUGIN=./plugin.so
OBJECT_AR=static_objects.a
TARGETS=$(PLUGIN) $(OBJECT_AR)

INCLUDES+=-I$(VALA_HOME)/aroop/core/inc
LIBS+=-L$(VALA_HOME)/aroop/core/ -laroop_core
include $(SHOTODOL_HOME)/build/platform.mk
include includes.mk

# use -fPIC when building shared object
CFLAGS+=-fPIC

all:objects $(TARGETS)

objects:preobjects $(OBJECTS)

preobjects:
	mkdir -p $(OBJDIR)/

$(OBJDIR)/%.o:vsrc/%.c
	$(CC) $(CFLAGS) -c $(INCLUDES) $< -o $@

$(OBJDIR)/%.o:csrc/%.c
	$(CC) $(CFLAGS) -c $(INCLUDES) $< -o $@

$(PLUGIN): $(OBJECT_AR)
	$(CC) --shared -o $(PLUGIN) $(LIBS) $(OBJECTS)

$(OBJECT_AR):objects
	$(AR) crv $@ $(OBJECTS)

clean:objectclean pluginclean

pluginclean:
	$(RM) $(TARGETS)

objectclean:
	$(RM) $(OBJDIR)/*.o
	
