
DB_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/db/vsrc/*.c)
DB_VSOURCE_BASE=$(basename $(notdir $(DB_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(DB_VSOURCE_BASE)))

