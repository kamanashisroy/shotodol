using aroop;
using shotodol;
using shotodol_platform;

/**
 * \ingroup core
 * \defgroup console Console command support(console)
 */
/** \addtogroup console
 *  @{
 */
public class Console : ModulePlugin {

	ConsoleTest? ct = null;
	ConsoleCommand? ccmd = null;
	WatchdogCommand? wcmd = null;
	public override int init() {
		ccmd = new ConsoleCommand();
		wcmd = new WatchdogCommand();
		CommandServer.server.cmds.register(ccmd);
		CommandServer.server.cmds.register(wcmd);
		ct = new ConsoleTest();
		UnitTestModule.inst.register(ct);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(ccmd);
		CommandServer.server.cmds.unregister(wcmd);
		UnitTestModule.inst.unregister(ct);
		ccmd = null;
		wcmd = null;
		ct = null;
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

/* @} */
