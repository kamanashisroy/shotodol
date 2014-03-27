
CONFIG_ENGINE_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/config/vsrc/*.c)
CONFIG_ENGINE_VSOURCE_BASE=$(basename $(notdir $(CONFIG_ENGINE_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(CONFIG_ENGINE_VSOURCE_BASE)))

