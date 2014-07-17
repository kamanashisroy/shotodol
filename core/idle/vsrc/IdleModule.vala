using aroop;
using shotodol;

/** \addtogroup idle
 *  @{
 */
public class shotodol.IdleModule : DynamicModule {
	IdleModule() {
		estr nm = estr.set_static_string("idle");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		estr spindle = estr.set_static_string("MainSpindle");
		IdleCommand.IdleSpindle sp = new IdleCommand.IdleSpindle();
		Plugin.register(&spindle, new AnyInterfaceExtension(sp, this));
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new IdleCommand(sp), this));
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

