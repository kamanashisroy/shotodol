using aroop;
using shotodol;

/** \addtogroup profiler
 *  @{
 */
internal class ProfilerCommand : M100Command {
	etxt prfx;
	public ProfilerCommand() {
		base();
	}

	~ProfilerCommand() {
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("profiler");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) {
		core.memory_profiler_dump((contentLine) => {
			contentLine.concat_char('\n');
			pad.write(contentLine);
			return 0;
		});
		return 0;
	}
}
/* @} */
