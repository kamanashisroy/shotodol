ifneq ("$(LUA_LIB)", "n")
INCLUDES+=-Iinclude
INCLUDES+=-I/usr/include/lua$(LUA_LIB)
# pkg-config --libs --cflags lua5.1
LUA_CSOURCES=$(wildcard $(SHOTODOL_HOME)/linux/lua/csrc/*.c)
CSOURCES+=$(LUA_CSOURCES)
LUA_VSOURCE_BASE=$(basename $(notdir $(LUA_CSOURCES)))
OBJECTS+=$(addprefix $(OBJDIR)/, $(addsuffix .o,$(LUA_VSOURCE_BASE)))
endif
