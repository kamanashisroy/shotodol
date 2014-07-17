using aroop;
using shotodol;

/** \addtogroup profiler
 *  @{
 */
internal class ProfilerCommand : M100Command {
	public ProfilerCommand() {
		estr prfx = estr.set_static_string("profiler");
		base(&prfx);
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) {
		core.memory_profiler_dump((contentLine) => {
			contentLine.concat_char('\n');
			pad.write(contentLine);
			return 0;
		});
		return 0;
	}
}
/* @} */
