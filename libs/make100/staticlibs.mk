
MAKE100_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/make100/vsrc/*.c)
MAKE100_VSOURCE_BASE=$(basename $(notdir $(MAKE100_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(MAKE100_VSOURCE_BASE)))

