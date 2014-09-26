using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup command Command register system(command).
 * [Cohesion : Logical]
 */

/** \addtogroup command
 *  @{
 */
public class shotodol.CommandModule: DynamicModule {
	public static CommandModule? server;
	public M100CommandSet?cmds;
	bool freeze;
	public CommandModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		freeze = false;
		cmds = new M100CommandSet();
		ModuleLoader.singleton.loadStatic(new ProgrammingInstruction());
	}
	
	public override int init() {
		server = this;
		extring entry = extring.set_static_string("command");
		Plugin.register(&entry, new M100Extension(new QuitCommand(), this));
		Plugin.register(&entry, new M100Extension(new HelpCommand(), this));
		Plugin.register(&entry, new M100Extension(new ModuleCommand(), this));
		Plugin.register(&entry, new M100Extension(new PluginCommand(), this));
		Plugin.register(&entry, new M100Extension(new RehashCommand(), this));
		Plugin.register(&entry, new M100Extension(new MemoryTraceCommand(), this));
		entry.rebuild_and_set_static_string("onLoad");
		Plugin.register(&entry, new HookExtension(rehashHook, this));
		entry.rebuild_and_set_static_string("rehash");
		Plugin.register(&entry, new HookExtension(rehashHook, this));
		entry.rebuild_and_set_static_string("command/server");
		Plugin.register(&entry, new HookExtension(commandServerHook, this));
		entry.rebuild_and_set_static_string("onQuit");
		Plugin.register(&entry, new HookExtension((onQuitHook), this));
		rehashHook(null, null);
		return 0;
	}

	int onQuitHook(extring*msg, extring*output) {
		freeze = true;
		//server = null;
		cmds = null;
		return 0;
	}

	int rehashHook(extring*msg, extring*output) {
		if(freeze)
			return 0;
		extring command = extring.set_static_string("command");
		cmds.rehash(&command);
		return 0;
	}
	int commandServerHook(extring*callstr, extring*output) {
		if(freeze)
			return 0;
		if(callstr == null) return 0;
		if(output == null) {
			server.cmds.act_on(callstr, new StandardOutputStream(), null);
			return 0;
		}
		BufferedOutputStream pad = new BufferedOutputStream(4096);
		server.cmds.act_on(callstr, pad, null);
		pad.getAs(output);
		return 0;
	}
	public override int deinit() {
		server = null;
		cmds = null;
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CommandModule();
	}
}
/* @} */
