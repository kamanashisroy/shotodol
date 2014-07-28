using aroop;

/**
 * \ingroup script
 * \defgroup lua Lua scripting support
 */

/** \addtogroup lua
 *  @{
 */
namespace shotodol_lua {
	[CCode (cname="aroop_luafunction")]
	delegate int func(LuaStack l);
	[Compact]
	[CCode (cname="lua_State", cheader_filename = "shotodol_lua.h", free_function = "lua_close")]
	public class LuaStack {
		//[CCode (cname="luaL_newstate", cheader_filename = "shotodol_lua.h")]
		[CCode (cname="lua_impl_newstate", cheader_filename = "shotodol_lua.h")]
		public static unowned shotodol_lua.LuaStack create();
		//[CCode (cname="lua_impl_loadfile", cheader_filename = "shotodol_lua.h")]
		[CCode (cname="luaL_loadfile", cheader_filename = "shotodol_lua.h")]
		public int loadFile(string fn);
		[CCode (cname="lua_pcall", cheader_filename = "shotodol_lua.h")]
		public void call(int nargs, int nresults, int efuc);
		[CCode (cname="LUA_GLOBALSINDEX", cheader_filename = "shotodol_lua.h")]
		public static int GLOBAL_SPACE;
		[CCode (cname="lua_getfield", cheader_filename = "shotodol_lua.h")]
		public void getField(int space, string fname); // get the field in a table space
		[CCode (cname="lua_setfield", cheader_filename = "shotodol_lua.h")]
		public void setField(int space, string fname); // set the field in a table space
		[CCode (cname="lua_pushstring", cheader_filename = "shotodol_lua.h")]
		public void pushString(string value); // push string to the stack
		[CCode (cname="lua_impl_pushextring", cheader_filename = "shotodol_lua.h")]
		public void pushEXtring(extring*msg); // push string to the stack
		[CCode (cname="lua_pushinteger", cheader_filename = "shotodol_lua.h")]
		public void pushInt(int value); // push integer to the stack
		[CCode (cname="lua_tonumber", cheader_filename = "shotodol_lua.h")]
		public int toInt(int idx); // get a integer value from the stack
		[CCode (cname="lua_impl_get_xtring_as", cheader_filename = "shotodol_lua.h")]
		//[CCode (cname="luaL_checkstring", cheader_filename = "shotodol_lua.h")]
		public void getXtringAs(extring*x, int idx); // get a string value from the stack
		[CCode (cname="lua_isstring", cheader_filename = "shotodol_lua.h")]
		public bool isString(int idx); // check if the stack element is string
		[CCode (cname="lua_gettop", cheader_filename = "shotodol_lua.h")]
		public int getTop(); // number of arguments passed to a function
		[CCode (cname="lua_pop", cheader_filename = "shotodol_lua.h")]
		public int pop(int idx); // pop from stack
		[CCode (cname="lua_impl_set_output_stream", cheader_filename = "shotodol_lua.h")]
		public int setOutputStream(Replicable/* OutputStream */ data);
	}
}
/* @} */
