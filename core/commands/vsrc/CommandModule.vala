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
	public CommandModule() {
		extring nm = extring.set_static_string("commands");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		cmds = new M100CommandSet();
		ModuleLoader.singleton.loadStatic(new ProgrammingInstruction());
	}
	
	public override int init() {
		server = this;
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new QuitCommand(), this));
		Plugin.register(&command, new M100Extension(new HelpCommand(), this));
		Plugin.register(&command, new M100Extension(new ModuleCommand(), this));
		Plugin.register(&command, new M100Extension(new PluginCommand(), this));
		Plugin.register(&command, new M100Extension(new RehashCommand(), this));
		Plugin.register(&command, new M100Extension(new MemoryTraceCommand(), this));
		extring onLoad = extring.set_static_string("onLoad");
		Plugin.register(&onLoad, new HookExtension(rehashHook, this));
		extring rehash = extring.set_static_string("rehash");
		Plugin.register(&rehash, new HookExtension(rehashHook, this));
		extring cmdServ = extring.set_static_string("command/server");
		Plugin.register(&cmdServ, new HookExtension(commandServerHook, this));
		rehashHook(null, null);
		return 0;
	}
	int rehashHook(extring*msg, extring*output) {
		extring command = extring.set_static_string("command");
		cmds.rehash(&command);
		return 0;
	}
	int commandServerHook(extring*callstr, extring*output) {
		if(callstr == null) return 0;
		// now parse the callstr
		server.cmds.act_on(callstr, new StandardOutputStream(), null);
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
