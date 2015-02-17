using aroop;
using shotodol;

/**
 * \ingroup apps
 * \defgroup instant Instant module creates package for distribution
 */

/** \addtogroup instant
 *  @{
 */
public class shotodol.InstantModule : DynamicModule {
	InstantCommand?cmd;
	public InstantModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		cmd = null;
	}
	public override int init() {
		cmd = new InstantCommand();
		extring entry = extring.set_static_string("command");
		PluginManager.register(&entry, new M100Extension(cmd, this));
		entry.rebuild_and_set_static_string("rehash");
		PluginManager.register(&entry, new HookExtension(rehashHook, this));
		return 0;
	}
	int rehashHook(extring*msg, extring*output) {
		if(cmd == null)
			return 0;
		extring command = extring.set_static_string("command");
		cmd.cmds.rehash(&command);
		return 0;
	}
	public override int deinit() {
		cmd = null;
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new InstantModule();
	}
}
/* @} */

