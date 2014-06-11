
WATCHDOG_LIB_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/watchdog/vsrc/*.c)
WATCHDOG_LIB_VSOURCE_BASE=$(basename $(notdir $(WATCHDOG_LIB_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(WATCHDOG_LIB_VSOURCE_BASE)))

