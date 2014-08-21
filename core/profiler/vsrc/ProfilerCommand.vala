using aroop;
using shotodol;

/** \addtogroup profiler
 *  @{
 */
internal class ProfilerCommand : M100Command {
	enum Options {
		SHOW_HEAP = 1,
		SHOW_STRING,
		SHOW_ANY_OBJECT,
	}
	public ProfilerCommand() {
		extring prfx = extring.set_static_string("profiler");
		base(&prfx);
		addOptionString("-heap", M100Command.OptionType.NONE, Options.SHOW_HEAP, "Show all the memory allocated in all the factories");
		addOptionString("-string", M100Command.OptionType.NONE, Options.SHOW_STRING, "Dump the string buffers");
		addOptionString("-object", M100Command.OptionType.NONE, Options.SHOW_ANY_OBJECT, "Show the objects");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int duration = 1000;
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring? arg;
		if((arg = vals[Options.SHOW_STRING]) != null) {
			core.string_buffer_dump((contentLine) => {
				contentLine.concat_char('\n');
				pad.write(contentLine);
				return 0;
			});
			return 0;
		}
		core.memory_profiler_dump((contentLine) => {
			contentLine.concat_char('\n');
			pad.write(contentLine);
			return 0;
		});
		return 0;
	}
}
/* @} */
