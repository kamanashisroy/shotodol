using aroop;
using shotodol;

public class shotodol.CommandServer: Module {
	public static CommandServer server;
	Set<shotodol.Command> cmds;
	CommandServer() {
		cmds = Set<shotodol.Command>();
	}
	public int register(Command cmd) {
		cmds.add(cmd);
		return 0;
	}
	public int unregister(Command cmd) {
		// TODO fill me
		return 0;
	}
	public override int init() {
		server = this;
		return 0;
	}
	public override int deinit() {
		return 0;
	}
}
