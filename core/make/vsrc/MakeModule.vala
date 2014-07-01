using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */
public class shotodol.MakeModule : ModulePlugin {
	MakeCommand? cmd;
	MakeTest? mt;
	public override int init() {
		cmd = new MakeCommand(CommandServer.server.cmds);
		mt = new MakeTest();
		UnitTestModule.inst.register(mt);
		CommandServer.server.cmds.register(cmd);
		etxt cmd = etxt.from_static("make -f shotodol.mk -t all\n");
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
		return new MakeModule();
	}
}
/* @} */

