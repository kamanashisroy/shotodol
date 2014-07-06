
SHOTOPLUGIN_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/plugin/vsrc/*.c)
SHOTOPLUGIN_VSOURCE_BASE=$(basename $(notdir $(SHOTOPLUGIN_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(SHOTOPLUGIN_VSOURCE_BASE)))

