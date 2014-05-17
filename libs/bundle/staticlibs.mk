
BUNDLE_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/bundle/vsrc/*.c)
BUNDLE_VSOURCE_BASE=$(basename $(notdir $(BUNDLE_CSOURCES)))
OBJECTS+=$(addprefix $(PROJECT_OBJDIR)/, $(addsuffix .o,$(BUNDLE_VSOURCE_BASE)))

