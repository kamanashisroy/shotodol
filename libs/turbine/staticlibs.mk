#TURBINE_THE_THREAD_CSOURCES=$(wildcard $(SHOTODOL_HOME)/libs/turbine/vsrc/*.c)
#TURBINE_THE_THREAD_VSOURCE_BASE=$(basename $(notdir $(TURBINE_THE_THREAD_CSOURCES)))
#OBJECTS+=$(addprefix $(SHOTODOL_OBJ_DIR)/, $(addsuffix .o,$(TURBINE_THE_THREAD_VSOURCE_BASE)))
#OBJECTS+=$(SHOTODOL_HOME)/libs/turbine/static_objects.a
# I do not think this is a good idea
OBJECTS+=$(SHOTODOL_HOME)/build/.objects/Turbine.o
