
STR_ARMS_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/str_arms/vsrc/*.c)
STR_ARMS_VSOURCE_BASE=$(basename $(notdir $(STR_ARMS_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(STR_ARMS_VSOURCE_BASE)))

