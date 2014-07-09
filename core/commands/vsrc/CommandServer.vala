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
public class shotodol.CommandServer: ModulePlugin {
	public static CommandServer? server;
	public M100CommandSet cmds;
	public CommandServer() {
		name = etxt.from_static("commands");
		cmds = new M100CommandSet();
		ModuleLoader.singleton.loadStatic(new ProgrammingInstruction());
	}
	
	public override int init() {
		server = this;
		// quit command
		QuitCommand qtcmd = new QuitCommand();
		cmds.register(qtcmd);
		// help commands
		HelpCommand hlpcmd = new HelpCommand();
		cmds.register(hlpcmd);
		// module commands
		ModuleCommand mdcmd = new ModuleCommand();
		cmds.register(mdcmd);
		PluginCommand pcmd = new PluginCommand();
		cmds.register(pcmd);
		return 0;
	}
	public override int deinit() {
		server = null;
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CommandServer();
	}
}
/* @} */
