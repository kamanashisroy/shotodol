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
	extring NEWLINE;
	public JobCommand(ConsoleHistory gSp) {
		extring prefix = extring.set_static_string("jobs");
		base(&prefix);
		addOptionString("-x", M100Command.OptionType.INT, Options.CHILD, "Select a child process");
		addOptionString("-act", M100Command.OptionType.TXT, Options.ACT, "Execute a command");
		sp = gSp;
		NEWLINE = extring.set_static_string("\r\n");
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
			if(other == null) {
				extring dlg = extring.stack(128);
				dlg.printf("Job not found at %d\n", index);
				pad.write(&dlg);
				return 0;
			}
			
			if((arg = vals[Options.ACT]) == null) {
				return 0;
			}
			extring ccmd = extring.stack(arg.fly().length()+NEWLINE.length());
			ccmd.concat(arg);
			ccmd.concat(&NEWLINE);
			//pad.write(&ccmd);
			other.write(&ccmd);
			return 0;
		}
		extring dlg = extring.stack(128);
		dlg.printf("%u Jobs(%s)\n", sp.getChildCount(), sp.isParent?"parent":"child");
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
