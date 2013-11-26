using aroop;
using shotodol;

public class shotodol.MakeModule : Module {
	MakeCommand cmd;
	public override int init() {
		cmd = new MakeCommand();
		CommandServer.server.cmds.register(cmd);
		etxt cmd = etxt.from_static("make -f loader.mk -t all");
		CommandServer.server.act_on(&cmd, new StandardIO());
		return 0;
	}
	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new MakeModule();
	}
}

