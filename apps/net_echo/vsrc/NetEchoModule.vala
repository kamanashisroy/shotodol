using aroop;
using shotodol;

/**
 * \defgroup apps Application Plugins(apps)
 */
/**
 * \ingroup apps
 * \defgroup net_echo Echo Application(net_echo)
 */

/** \addtogroup net_echo
 *  @{
 */
public class shotodol.NetEchoModule : ModulePlugin {
	public NetEchoModule() {
		name = etxt.from_static("net_echo");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new Extension.for_service(new NetEchoCommand(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new NetEchoModule();
	}
}
/* @} */

