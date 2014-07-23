
SHOTOPOLLEN_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/renu/vsrc/*.c)
SHOTOPOLLEN_VSOURCE_BASE=$(basename $(notdir $(SHOTOPOLLEN_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(SHOTOPOLLEN_VSOURCE_BASE)))

