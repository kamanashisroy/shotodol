
PLATFORM_NET_CSOURCES=$(wildcard $(SHOTODOL_HOME)/$(PLATFORM)/platform_net/csrc/*.c)
PLATFORM_NET_VSOURCE_BASE=$(basename $(notdir $(PLATFORM_NET_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(PLATFORM_NET_VSOURCE_BASE)))
LIBS+=-lbluetooth

