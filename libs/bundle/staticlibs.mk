
BUNDLE_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/bundle/vsrc/*.c)
BUNDLE_VSOURCE_BASE=$(basename $(notdir $(BUNDLE_CSOURCES)))
OBJECTS+=$(addprefix  $(SHOTODOL_HOME)/build/.objects/, $(addsuffix .o,$(BUNDLE_VSOURCE_BASE)))

