#include "aroop/aroop_core.h"
#include "shotodol_lua.h"
#include "shotodol_iostream.h"

const static char *output_stream_type_name = "OutputStream";
const static char *ostrmvar = "ostrm";

static void* lua_impl_memcb(void *ud, void *ptr, size_t osize,size_t nsize) {
	(void)ud;  (void)osize;  /* not used */
	if (nsize == 0) {
		free(ptr);
		return NULL;
	}
	else
		return realloc(ptr, nsize);
}

static aroop_cl_shotodol_shotodol_output_stream*lua_impl_get_ostrm_as(lua_State*script) {
	lua_getglobal(script, ostrmvar);
	aroop_cl_shotodol_shotodol_output_stream*ostrm = (void*)lua_touserdata(script, -1);
	lua_pop(script, 1);
	return ostrm;
}

static int lua_impl_shotodol_write(lua_State*script) {
	aroop_txt_t x;
	aroop_memclean_raw2(&x);
	lua_impl_get_xtring_as(script, &x, -1);
	aroop_cl_shotodol_shotodol_output_stream*ostrm = lua_impl_get_ostrm_as(script);
	void*err;
	aroop_cl_shotodol_shotodol_output_stream_write(ostrm, &x, err);
	return 0;
}

lua_State* lua_impl_newstate() {
	lua_State*x = lua_newstate(lua_impl_memcb, NULL);
}

void lua_impl_get_xtring_as(lua_State*script, aroop_txt_t*x, int idx) {
	if(!x) {
		lua_pop(script, 1);
		return;
	}
	size_t len = 0;
	const char*content = lua_tolstring(script, idx, &len);
	if(content) {
		aroop_txt_embeded_rebuild_and_set_content(x, content, len, NULL);
	} else
		aroop_txt_destroy(x);
	lua_pop(script, 1);
}

void lua_impl_pushextring(lua_State*script, aroop_txt_t*msg) {
	lua_pushlstring(script, (msg && msg->str)?msg->str:"", msg?msg->len:0);
}

void lua_impl_set_output_stream(lua_State*script, void*ostrm) {
	lua_newtable(script);
	lua_pushstring(script, "write");
	lua_pushcfunction(script, lua_impl_shotodol_write);
	lua_settable(script, -3);
	lua_setglobal(script, output_stream_type_name); // Stack: MyLib meta

	lua_pushlightuserdata(script, ostrm);
	lua_setglobal(script, ostrmvar);
	lua_pop(script, 1);
}

