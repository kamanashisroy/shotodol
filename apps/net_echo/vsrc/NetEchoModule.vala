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
public class shotodol.NetEchoModule : DynamicModule {
	public NetEchoModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		base(&nm);
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new NetEchoCommand(), this));
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

