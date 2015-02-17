using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup fork Forking a new process support.
 */
/** \addtogroup fork
 *  @{
 */
public class shotodol.fork.ForkModule : DynamicModule {
	public ForkModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		ForkCommand cmd = new ForkCommand();
		extring entry = extring.set_static_string("command");
		PluginManager.register(&entry, new M100Extension(cmd, this));
		entry.rebuild_and_set_static_string("fork");
		PluginManager.register(&entry, new HookExtension(cmd.forkHook, this));
		entry.rebuild_and_set_static_string("onFork/complete");
		//(new ShakeHook(&entry, this)).plug();
		PluginManager.register(&entry, new ShakeHook(&entry, this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ForkModule();
	}
}

/* @} */
