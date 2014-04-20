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
	ProfilerCommand? cmd;
	public override int init() {
		cmd = new ProfilerCommand();
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
		return new ProfilerModule();
	}
}
/* @} */

