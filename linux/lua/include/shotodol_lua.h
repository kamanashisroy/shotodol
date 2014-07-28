#ifndef SHOTODOL_LUALIB_INCLUDE_H
#define SHOTODOL_LUALIB_INCLUDE_H

//#define LUA_LIB
//#include "lualib.h"
//#include "lauxlib.h"
#include "lua.h"
#include "aroop/aroop_core.h"
#include "aroop/core/xtring.h"
lua_State*lua_impl_newstate();
void lua_impl_get_xtring_as(lua_State*script, aroop_txt_t*x, int idx);
void lua_impl_set_output_stream(lua_State*script, void*strmData);

#endif //SHOTODOL_PLUGIN_INCLUDE_H
