using aroop;
using shotodol;

/** \addtogroup idle
 *  @{
 */
public class shotodol.IdleModule : ModulePlugin {
	IdleCommand? cmd;
	public override int init() {
		cmd = new IdleCommand();
		CommandServer.server.cmds.register(cmd);
		return 0;
	}
	public override int deinit() {
		CommandServer.server.cmds.unregister(cmd);
		cmd = null;
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new IdleModule();
	}
}
/* @} */

