
PADELFIBER_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/fiber/vsrc/*.c)
PADELFIBER_VSOURCE_BASE=$(basename $(notdir $(PADELFIBER_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(PADELFIBER_VSOURCE_BASE)))

