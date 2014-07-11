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
		txt command = new txt.from_static("command");
		Plugin.register(command, new Extension.for_service(new QuitCommand(), this));
		Plugin.register(command, new Extension.for_service(new HelpCommand(), this));
		Plugin.register(command, new Extension.for_service(new ModuleCommand(), this));
		Plugin.register(command, new Extension.for_service(new PluginCommand(), this));
		Plugin.register(command, new Extension.for_service(new RehashCommand(cmds), this));
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
		return new CommandServer();
	}
}
/* @} */
