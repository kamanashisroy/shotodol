using aroop;
using shotodol;

/** \addtogroup net_echo
 *  @{
 */
public class shotodol.NetEchoModule : ModulePlugin {
	NetEchoCommand? cmd;
	public override int init() {
		cmd = new NetEchoCommand();
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
		return new NetEchoModule();
	}
}
/* @} */

