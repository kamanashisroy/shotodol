using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.JobCommand : shotodol.M100Command {
	ConsoleHistory sp;
	extring NEWLINE;
	public JobCommand(ConsoleHistory gSp) {
		extring prefix = extring.set_static_string("job");
		base(&prefix);
		sp = gSp;
		NEWLINE = extring.set_static_string("\r\n");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
#if false
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
#else
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineExpression.next_token(&inp, &token); // second token
		LineExpression.next_token(&inp, &token); // second token
		do {
			if(token.is_empty())
				break;
			int index = token.to_int();
			inp.shift(1);
			if(inp.is_empty())
				break;
			OutputStream?other = sp.getChildOutputStream(index);
			if(other == null) {
				extring dlg = extring.stack(128);
				dlg.printf("Job not found at %d\n", index);
				pad.write(&dlg);
				return 0;
			}
			
			extring ccmd = extring.stack(inp.length()+NEWLINE.length());
			ccmd.concat(&inp);
			ccmd.concat(&NEWLINE);
			//pad.write(&ccmd);
			other.write(&ccmd);
			return 0;
		} while(false);
#endif
		extring dlg = extring.stack(128);
		dlg.printf("%u Jobs(%s)\n", sp.getChildCount(), sp.isParent()?"parent":"child");
		pad.write(&dlg);
		return 0;
	}
	public override int desc(M100Command.CommandDescType tp, OutputStream pad) { // This describes the application of the command to the user
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_FULL:
			extring x = extring.stack(512); // allocate memory in stack
			x.concat_string("\tJob command executes command in background processes.\n");
			x.concat_string("EXAMPLE:\n");
			x.concat_string("\t`job 1 ping` sends ping command to #1 process.\n");
			pad.write(&x);
			break;
		}
		return base.desc(tp, pad);
	}
}
/* @} */
