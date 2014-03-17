
PLATFORM_EXTRA_CSOURCES=$(wildcard $(SHOTODOL_HOME)/$(PLATFORM)/platform_extra/vsrc/*.c)
PLATFORM_EXTRA_VSOURCE_BASE=$(basename $(notdir $(PLATFORM_EXTRA_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(PLATFORM_EXTRA_VSOURCE_BASE)))

