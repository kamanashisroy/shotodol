using aroop;
using shotodol;

/**
 * \ingroup commandserver
 * \defgroup command Command
 */


/**
 * \ingroup core
 * \defgroup commandserver Command Server
 * [Cohesion : Logical]
 */

/** \addtogroup commandserver
 *  @{
 * \image html command_component.svg "Component Diagram"
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
		PluginManager.register(&entry, new M100Extension(new QuitCommand(), this));
		PluginManager.register(&entry, new M100Extension(new HelpCommand(), this));
		PluginManager.register(&entry, new M100Extension(new ModuleCommand(), this));
		PluginManager.register(&entry, new M100Extension(new PluginCommand(), this));
		PluginManager.register(&entry, new M100Extension(new RehashCommand(), this));
		PluginManager.register(&entry, new M100Extension(new MemoryTraceCommand(), this));
		PluginManager.register(&entry, new M100Extension(new StatusCommand(), this));
		entry.rebuild_and_set_static_string("onLoad");
		PluginManager.register(&entry, new HookExtension(rehashHook, this));
		entry.rebuild_and_set_static_string("rehash");
		PluginManager.register(&entry, new HookExtension(rehashHook, this));
		entry.rebuild_and_set_static_string("command/server");
		PluginManager.register(&entry, new HookExtension(commandServerHook, this));
		entry.rebuild_and_set_static_string("command/server/quiet");
		PluginManager.register(&entry, new HookExtension(commandServerQuietHook, this));
		entry.rebuild_and_set_static_string("onQuit");
		PluginManager.register(&entry, new HookExtension((onQuitHook), this));
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
	int commandServerQuietHook(extring*callstr, extring*output) {
		if(freeze)
			return 0;
		if(callstr == null) return 0;
		bool oldQuiet = server.cmds.quiet;
		if(output == null) {
			server.cmds.quiet = true;
			server.cmds.act_on(callstr, new StandardOutputStream(), null);
			server.cmds.quiet = oldQuiet;
			return 0;
		}
		BufferedOutputStream pad = new BufferedOutputStream(4096);
		server.cmds.quiet = true;
		server.cmds.act_on(callstr, pad, null);
		server.cmds.quiet = oldQuiet;
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
