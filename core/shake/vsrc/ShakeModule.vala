using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */
public class shotodol.ShakeModule : DynamicModule {
	public ShakeModule() {
		estr nm = estr.set_static_string("shake");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ShakeCommand(), this));
		estr test = estr.set_static_string("unittest");
		Plugin.register(&test, new AnyInterfaceExtension(new ShakeTest(), this));
		estr onLoad = estr.set_static_string("onLoad");
		Plugin.register(&onLoad, new HookExtension(greetHook, this));
		return 0;
	}
	int greetHook(estr*msg, estr*output) {
		estr greet = estr.set_static_string("echo Welcome to opensource shotodol environment. This toy comes with no guaranty. Use it at your own risk.\n");
		CommandModule.server.cmds.act_on(&greet, new StandardOutputStream(), null);
		estr cmd = estr.set_static_string("shake -f ./shotodol.ske -t onLoad\n");
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

