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
	public M100CommandSet cmds;
	public CommandModule() {
		estr nm = estr.set_static_string("commands");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
		cmds = new M100CommandSet();
		ModuleLoader.singleton.loadStatic(new ProgrammingInstruction());
	}
	
	public override int init() {
		server = this;
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new QuitCommand(), this));
		Plugin.register(&command, new M100Extension(new HelpCommand(), this));
		Plugin.register(&command, new M100Extension(new ModuleCommand(), this));
		Plugin.register(&command, new M100Extension(new PluginCommand(), this));
		Plugin.register(&command, new M100Extension(new RehashCommand(), this));
		estr onLoad = estr.set_static_string("onLoad");
		Plugin.register(&onLoad, new HookExtension(rehashHook, this));
		estr rehash = estr.set_static_string("rehash");
		Plugin.register(&rehash, new HookExtension(rehashHook, this));
		cmds.rehash();
		return 0;
	}
	int rehashHook(estr*msg, estr*output) {
		cmds.rehash();
		return 0;
	}
	public override int deinit() {
		server = null;
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CommandModule();
	}
}
/* @} */
