using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.JobCommand : shotodol.M100Command {
	enum Options {
		ACT = 1,
		CHILD,
	}
	ConsoleHistory sp;
	public JobCommand(ConsoleHistory gSp) {
		extring prefix = extring.set_static_string("jobs");
		base(&prefix);
		addOptionString("-x", M100Command.OptionType.INT, Options.CHILD, "Select a child process");
		addOptionString("-act", M100Command.OptionType.TXT, Options.ACT, "Execute a command");
		sp = gSp;
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring? arg;
		if((arg = vals[Options.CHILD]) != null) {
			int index = arg.fly().to_int();
			OutputStream?other = sp.getChildOutputStream(index);
			if(other == null)
				return 0;
			
			if((arg = vals[Options.CHILD]) == null) {
				return 0;
			}
			other.write(arg);
			return 0;
		}
		extring dlg = extring.stack(128);
		dlg.printf("%u Jobs\n", sp.getChildCount());
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
