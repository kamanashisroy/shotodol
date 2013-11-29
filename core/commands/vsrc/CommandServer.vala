using aroop;
using shotodol;

public class shotodol.CommandServer: ModulePlugin {
	public static CommandServer server;
	public CommandSet cmds;
	public CommandServer() {
		cmds = new CommandSet();
	}
	public int act_on(etxt*cmd_str, OutputStream pad) {
		if(cmd_str.char_at(0) == '#') { // skip the comments
			return 0;
		}
		M100Command? mycmd = cmds.percept(cmd_str);
		//io.say_static("acting ..\n");
		if(mycmd == null) {
			// show menu ..
			print("Command not found. Please try one of the following..\n");
			cmds.list(pad);
			return 0;
		}
		mycmd.act_on(cmd_str, pad);
		return 0;
	}
	
	public override int init() {
		server = this;
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CommandServer();
	}
}
