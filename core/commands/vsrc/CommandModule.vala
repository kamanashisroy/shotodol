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
	class CommandOnLoad : Extension {
		public CommandOnLoad(Module mod) {
			base(mod);
		}
		public override int act(etxt*msg, etxt*output) {
			server.cmds.rehash();
			return 0;
		}
	}
	public static CommandModule? server;
	public M100CommandSet cmds;
	public CommandModule() {
		name = etxt.from_static("commands");
		cmds = new M100CommandSet();
		ModuleLoader.singleton.loadStatic(new ProgrammingInstruction());
	}
	
	public override int init() {
		server = this;
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new QuitCommand(), this));
		Plugin.register(command, new M100Extension(new HelpCommand(), this));
		Plugin.register(command, new M100Extension(new ModuleCommand(), this));
		Plugin.register(command, new M100Extension(new PluginCommand(), this));
		Plugin.register(command, new M100Extension(new RehashCommand(cmds), this));
		txt onLoad = new txt.from_static("onLoad");
		Plugin.register(onLoad, new CommandOnLoad(this));
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
