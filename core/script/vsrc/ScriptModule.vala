using aroop;
using shotodol;

/** \addtogroup script
 *  @{
 */
public class shotodol.ScriptModule : DynamicModule {
	public ScriptModule() {
		extring nm = extring.set_static_string("script");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
#if LUA_LIB
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ScriptCommand(), this));
		extring rehash = extring.set_static_string("rehash");
		Plugin.register(&rehash, new HookExtension(onRehash, this));
#endif
		return 0;
	}
#if LUA_LIB
	int onRehash(extring*msg, extring*output) {
		extring cmd = extring.set_static_string("script -f ./shotodol.lua -t rehash\n");
		CommandModule.server.cmds.act_on(&cmd, new StandardOutputStream(), null);
		return 0;
	}
#endif
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ScriptModule();
	}
}
/* @} */

