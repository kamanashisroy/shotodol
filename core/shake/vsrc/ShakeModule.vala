using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */
public class shotodol.ShakeModule : ModulePlugin {
	ShakeCommand? cmd;
	ShakeTest? mt;
	public override int init() {
		cmd = new ShakeCommand(CommandServer.server.cmds);
		mt = new ShakeTest();
		UnitTestModule.inst.register(mt);
		CommandServer.server.cmds.register(cmd);
		etxt cmd = etxt.from_static("shake -f ./shotodol.ske -t all\n");
		CommandServer.server.cmds.act_on(&cmd, new StandardOutputStream(), null);
		return 0;
	}
	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		UnitTestModule.inst.unregister(mt);
		cmd = null;
		mt = null;
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ShakeModule();
	}
}
/* @} */

