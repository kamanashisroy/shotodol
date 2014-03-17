
IOSTREAM_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/iostream/vsrc/*.c)
IOSTREAM_VSOURCE_BASE=$(basename $(notdir $(IOSTREAM_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(IOSTREAM_VSOURCE_BASE)))

