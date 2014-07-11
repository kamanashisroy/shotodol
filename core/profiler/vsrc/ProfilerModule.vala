using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup profiler Profiler
 */

/** \addtogroup profiler
 *  @{
 */
public class shotodol.ProfilerModule : ModulePlugin {
	public ProfilerModule() {
		name = etxt.from_static("net_echo");
	}

	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new Extension.for_service(new ProfilerCommand(), this));
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

