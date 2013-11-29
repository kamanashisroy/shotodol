using aroop;
using shotodol;

public class shotodol.MakeModule : ModulePlugin {
	MakeCommand cmd;
	public override int init() {
		cmd = new MakeCommand();
		CommandServer.server.cmds.register(cmd);
		etxt cmd = etxt.from_static("make -f shotodol.mk -t all");
		CommandServer.server.act_on(&cmd, new StandardOutputStream());
		return 0;
	}
	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new MakeModule();
	}
}

