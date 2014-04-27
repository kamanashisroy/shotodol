using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
public class shotodol.CommandSet: Replicable {
	Set<M100Command> cmds;
	BrainEngine<M100Command> be;
	public CommandSet() {
		cmds = Set<M100Command>();
		be = new BrainEngine<M100Command>();
		// quit command
		QuitCommand qtcmd = new QuitCommand();
		register(qtcmd);
		// help commands
		HelpCommand hlpcmd = new HelpCommand();
		register(hlpcmd);
		// module commands
		ModuleCommand mdcmd = new ModuleCommand();
		register(mdcmd);
	}
	~CommandSet() {
		cmds.destroy();
	}
	public int list(OutputStream pad) {		
		cmds.visit_each((data) =>{
			unowned M100Command cmd = ((container<M100Command>)data).get();
			cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
			//etxt*prefix = cmd.get_prefix();
			//if(prefix == null) return 0;
			//if(!prefix.equals(cmd_str)) return 0;
			//mycmd = cmd;
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}
	public int register(M100Command cmd) {
		print("Registering %s command\n", cmd.get_prefix().to_string());
		cmds.add(cmd);
		be.memorize_etxt(cmd.get_prefix(), cmd);
		return 0;
	}
	public int unregister(M100Command cmd) {
		// TODO fill me
		return 0;
	}
	public M100Command? percept(etxt*cmd_str) {
		return be.percept_prefix_match(cmd_str);//be.direction(cmd_str);
	}
}
/* @} */
