using aroop;
using shotodol;

/**
 * \ingroup apps
 * \defgroup instant Instant module creates package for distribution
 */

/** \addtogroup instant
 *  @{
 */
public class shotodol.InstantModule : DynamicModule {
	public InstantModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring entry = extring.set_static_string("command");
		Plugin.register(&entry, new M100Extension(new InstantCommand(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new InstantModule();
	}
}
/* @} */

