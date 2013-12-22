
DB_CSOURCES=$(wildcard $(ROOPKOTHA_HOME)/libs/doc/vsrc/*.c)
DB_VSOURCE_BASE=$(basename $(notdir $(DB_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(DB_VSOURCE_BASE)))

