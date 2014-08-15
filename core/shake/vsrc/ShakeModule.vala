using aroop;
using shotodol;

/** \addtogroup shake
 *  @{
 */
public class shotodol.ShakeModule : DynamicModule {
	public ShakeModule() {
		extring nm = extring.set_static_string("shake");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ShakeCommand(), this));
		extring test = extring.set_static_string("unittest");
		Plugin.register(&test, new AnyInterfaceExtension(new ShakeTest(), this));
		extring onLoad = extring.set_static_string("onLoad");
		Plugin.register(&onLoad, new HookExtension(greetHook, this));
		return 0;
	}
	int greetHook(extring*msg, extring*output) {
		extring greet = extring.set_static_string("echo Welcome to opensource shotodol environment. This toy comes with no guaranty. Use it at your own risk.\n");
		CommandModule.server.cmds.act_on(&greet, new StandardOutputStream(), null);
		extring cmd = extring.set_static_string("shake -f ./autoload/shotodol.ske -t onLoad\n");
		CommandModule.server.cmds.act_on(&cmd, new StandardOutputStream(), null);
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ShakeModule();
	}
}
/* @} */

