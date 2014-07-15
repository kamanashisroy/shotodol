using aroop;
using shotodol;

/** \addtogroup idle
 *  @{
 */
public class shotodol.IdleModule : DynamicModule {
	IdleModule() {
		name = etxt.from_static("idle");
	}
	public override int init() {
		txt spindle = new txt.from_static("MainSpindle");
		IdleCommand.IdleSpindle sp = new IdleCommand.IdleSpindle();
		Plugin.register(spindle, new AnyInterfaceExtension(sp, this));
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new IdleCommand(sp), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new IdleModule();
	}
}
/* @} */

