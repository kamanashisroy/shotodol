using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.MemoryTraceCommand : M100Command {
	enum Options {
		ON = 1,
		OFF,
		STATUS,
	}
	bool isRunning;
	public MemoryTraceCommand() {
		var prefix = extring.copy_static_string("mtrace");
		base(&prefix);
		addOptionString("-on", M100Command.OptionType.NONE, Options.ON, "Start memory trace"); 
		addOptionString("-off", M100Command.OptionType.NONE, Options.OFF, "Stop memory trace"); 
		addOptionString("-status", M100Command.OptionType.NONE, Options.STATUS, "trace status"); 
		isRunning = false;
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?ex = vals[Options.ON];
		if(ex != null) {
			shotodol_platform.MemoryTrace.start();
			isRunning = true;
			return 0;
		}
		ex = vals[Options.OFF];
		if(ex != null) {
			shotodol_platform.MemoryTrace.stop();
			isRunning = false;
			return 0;
		}
		if(isRunning) {
			extring dlg = extring.set_static_string("Memory tracer is ON.");
			pad.write(&dlg);
		} else {
			extring dlg = extring.set_static_string("Memory tracer is OFF.");
			pad.write(&dlg);
		}
		extring dlg = extring.set_static_string("Note, if your are using gnu C compiler then you need to set MALLOC_TRACE environment variable to a filename to make it work.\n");
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
