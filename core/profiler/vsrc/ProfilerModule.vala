using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup profiler Profiler
 */

/** \addtogroup profiler
 *  @{
 */
public class shotodol.ProfilerModule : DynamicModule {
	public ProfilerModule() {
		estr nm = estr.set_static_string("profiler");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ProfilerCommand(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ProfilerModule();
	}
}
/* @} */

