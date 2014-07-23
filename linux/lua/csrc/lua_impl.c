#include "aroop_core.h"
#include "core/txt.h"
#include "shotodol_lua.h"


static void* lua_impl_memcb(void *ud, void *ptr, size_t osize,size_t nsize) {
	(void)ud;  (void)osize;  /* not used */
	if (nsize == 0) {
		free(ptr);
		return NULL;
	}
	else
		return realloc(ptr, nsize);
}

static int lua_impl_shotodol_write(lua_State*script) {
	size_t len = 0;
	const char*str = lua_tolstring(script, -1, &len);
	printf("%s\n", str);
	return 0;
}

lua_State* lua_impl_newstate() {
	lua_State*x = lua_newstate(lua_impl_memcb, NULL);
}

void lua_impl_get_xtring_as(lua_State*script, aroop_txt_t*x, int idx) {
	size_t len = 0;
	const char*content = lua_tolstring(script, idx, &len);
	if(content) {
#if false
		aroop_txt_t tmp;
		aroop_txt_embeded_set_content(&tmp, content, len, NULL);
		aroop_txt_embeded_rebuild_copy_on_demand(x, &tmp);
#else
		aroop_txt_embeded_rebuild_and_set_content(x, content, len, NULL);
#endif
	} else
		aroop_txt_destroy(x);
}

void lua_impl_set_output_stream(lua_State*script, void*strmData) {
	lua_pushcfunction(script, lua_impl_shotodol_write);
	lua_setglobal(script, "xwrite");
	//lua_pushuserdata(script, strmData);
	//lua_setglobal(script, "shotodol_stream");
}

