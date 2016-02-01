using aroop;
using shotodol;
using shotodol_platform;

/** \addtogroup good_luck
 *  @{
 */

internal class shotodol.SystemCommand : M100Command {
	public SystemCommand() {
		extring prefix = extring.set_static_string("system");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineExpression.next_token(&inp, &token); 
		if(inp.is_empty()) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		inp.shift(1);
		Execute.system(inp.to_string());
		return 0;
	}

	public override int desc(M100Command.CommandDescType tp, OutputStream pad) {
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_FULL:
			extring x = extring.stack(512);
			x.concat_string("\tsystem command executes a platform shell command.\n");
			x.concat_string("EXAMPLE:\n");
			x.concat_string("\t`system pwd` will print name of current/working directory.\n");
			pad.write(&x);
			break;
		}
		return base.desc(tp, pad);
	}
}
/* @} */
