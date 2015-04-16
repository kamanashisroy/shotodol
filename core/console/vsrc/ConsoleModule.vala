using aroop;
using shotodol;
using shotodol_platform;

/**
 * \ingroup core
 * \defgroup console Console command support(console)
 */
/** \addtogroup console
 *  @{
 */
public class shotodol.ConsoleModule : DynamicModule {

	public ConsoleModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring entry = extring.set_static_string("command");
		PluginManager.register(&entry, new M100Extension(new WatchdogCommand(), this));
		entry.rebuild_and_set_static_string("unittest");
		PluginManager.register(&entry, new AnyInterfaceExtension(new ConsoleTest(), this));
		entry.rebuild_and_set_static_string("onLoad");
		PluginManager.register(&entry, new HookExtension(onLoadHook, this));
		return 0;
	}

	int onLoadHook(extring*msg, extring*output) {
		bool hasConsole = true;
		Unbundler ubndlr = Unbundler();
		ubndlr.build(msg, BundlerAffixes.PREFIX);
		do {
			try {
				int key = ubndlr.next();
				if(key == -1) break;
				if(ubndlr.getContentType() != BundledContentType.STRING_CONTENT) continue;
				extring uarg = extring.set_content((string)ubndlr.getContent(), (int)ubndlr.getContentLength());
				if(uarg.equals_string("-noconsole")) {
					hasConsole = false;
				} else if(uarg.equals_string("--help")) {
					core.debug_print("-noconsole Use this argument to run the shotodol without shell.\n");
					hasConsole = false;
				}
			} catch(BundlerError err) {
				break;
			}
		} while(true);
		if(!hasConsole) return 0;

		core.debug_print("Loading console spindle\n");
		extring entry = extring.set_static_string("MainFiber");
		ConsoleHistory sp = new ConsoleHistory();
		PluginManager.register(&entry, new AnyInterfaceExtension(sp, this));
		entry.rebuild_and_set_static_string("command");
		PluginManager.register(&entry, new M100Extension(new PingCommand(), this));
		PluginManager.register(&entry, new M100Extension(new ConsoleCommand(sp), this));
		PluginManager.register(&entry, new M100Extension(new JobCommand(sp), this));
		entry.rebuild_and_set_static_string("onFork/before");
		PluginManager.register(&entry, new HookExtension(sp.onFork_Before, this));
		entry.rebuild_and_set_static_string("onFork/after/parent");
		PluginManager.register(&entry, new HookExtension(sp.onFork_After_Parent, this));
		entry.rebuild_and_set_static_string("onFork/after/child");
		PluginManager.register(&entry, new HookExtension(sp.onFork_After_Child, this));
		entry.rebuild_and_set_static_string("onQuit/soft");
		PluginManager.register(&entry, new HookExtension(sp.onQuitHook, this));
		entry.rebuild_and_set_static_string("status");
		PluginManager.register(&entry, new HookExtension(sp.statusHook, this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ConsoleModule();
	}
}

/* @} */
