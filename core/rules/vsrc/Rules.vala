using aroop;
using shotodol;

public class shotodol.Rules : Module {
	// TODO write makefile parser
	RulesCommand cmd;
	public override int init() {
		// TODO load commands for executing makefile
		cmd = new RulesCommand();
		CommandServer.server.cmds.register(cmd);
		return 0;
	}
	public override int deinit() {
		// TODO cleanup
		CommandServer.server.cmds.unregister(cmd);
		return 0;
	}
}

