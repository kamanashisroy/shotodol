using aroop;
using shotodol;

public class shotodol.CommandServer: Module {
	public static CommandServer server;
	Set<shotodol.Command> cmds;
	public CommandServer() {
		cmds = Set<shotodol.Command>();
	}
	~CommandServer() {
		cmds.destroy();
	}
	public int register(Command cmd) {
		cmds.add(cmd);
		return 0;
	}
	public int unregister(Command cmd) {
		// TODO fill me
		return 0;
	}
	public int act_on(etxt cmd_str, StandardIO io) {
		Command? mycmd = null;
		cmds.visit_each((data) =>{
				unowned Command cmd = ((container<Command>)data).get();
				//if(cmd.cmdprefix.
				return 0;
			}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}
	public override int init() {
		server = this;
		return 0;
	}
	public override int deinit() {
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CommandServer();
	}
}
