
CORE_BASE_CSOURCES=$(wildcard $(SHOTODOL_HOME)/core/base/vsrc/*.c)
CORE_BASE_VSOURCE_BASE=$(basename $(notdir $(CORE_BASE_CSOURCES)))
OBJECTS+=$(addprefix  $(SHOTODOL_HOME)/build/.objects/, $(addsuffix .o,$(CORE_BASE_VSOURCE_BASE)))

