using aroop;
using shotodol;

/** \addtogroup idle
 *  @{
 */
public class shotodol.IdleModule : ModulePlugin {
	IdleModule() {
		name = etxt.from_static("net_echo");
	}
	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new Extension.for_service(new IdleCommand(), this));
		return 0;
	}
	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new IdleModule();
	}
}
/* @} */

