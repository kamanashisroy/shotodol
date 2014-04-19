using aroop;
using shotodol;
using shotodol_platform;

/** \addtogroup fileconfig
 *  @{
 */
public class FileConfig : ModulePlugin {

	FileConfigTest? ct = null;
	FileConfigCommand? ccmd = null;
	public override int init() {
		//new Watchdog(new StandardOutputStream());
		ccmd = new FileConfigCommand();
		CommandServer.server.cmds.register(ccmd);
		ct = new FileConfigTest();
		UnitTestModule.inst.register(ct);
		return 0;
	}

	public override int deinit() {
		CommandServer.server.cmds.unregister(ccmd);
		UnitTestModule.inst.unregister(ct);
		ccmd = null;
		ct = null;
		DefaultConfigEngine.setDefault(null);
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new FileConfig();
	}
}
/* @} */
