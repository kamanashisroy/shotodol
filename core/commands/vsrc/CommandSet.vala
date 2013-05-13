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
	public int register(Command cmd) {
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
