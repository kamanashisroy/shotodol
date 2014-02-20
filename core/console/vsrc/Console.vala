using aroop;
using shotodol;
using shotodol_platform;

public class Console : ModulePlugin {

	ConsoleTest? ct = null;
	ConsoleCommand? ccmd = null;
	public override int init() {
		new Watchdog(new StandardOutputStream());
		ccmd = new ConsoleCommand();
		CommandServer.server.cmds.register(ccmd);
		ct = new ConsoleTest();
		UnitTestModule.inst.register(ct);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(ccmd);
		UnitTestModule.inst.unregister(ct);
		ccmd = null;
		ct = null;
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

