
INCLUDES+=-Iinclude
ifneq ("$(LUA_LIB)", "n")
INCLUDES+=-I/usr/include/lua$(LUA_LIB)
endif
#include ../../linux/lua/includes.mk
