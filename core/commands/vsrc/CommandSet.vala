using aroop;
using shotodol;

public class shotodol.CommandSet: Replicable {
	Set<shotodol.Command> cmds;
	BrainEngine<Command> be;
	public CommandSet() {
		cmds = Set<shotodol.Command>();
		be = new BrainEngine<Command>();
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
	public int list(StandardIO io) {		
		cmds.visit_each((data) =>{
			unowned Command cmd = ((container<Command>)data).get();
			cmd.desc(io, Command.CommandDescType.COMMAND_DESC_TITLE);
			//etxt*prefix = cmd.get_prefix();
			//if(prefix == null) return 0;
			//if(!prefix.equals(cmd_str)) return 0;
			//mycmd = cmd;
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}
	public int register(Command cmd) {
		print("Registering %s command\n", cmd.get_prefix().to_string());
		cmds.add(cmd);
		be.memorize_etxt(cmd.get_prefix(), cmd);
		return 0;
	}
	public int unregister(Command cmd) {
		// TODO fill me
		return 0;
	}
	public Command? percept(etxt*cmd_str) {
		return be.percept_prefix_match(cmd_str);//be.direction(cmd_str);
	}
}
