using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.SetVariableCommand : M100Command {
	enum Options {
		VAR = 1,
		VAL,
	}
	public SetVariableCommand() {
		extring prfx = extring.copy_static_string("set");
		base(&prfx);
		addOptionString("-var", M100Command.OptionType.TXT, Options.VAR, "Destination variable name");
		addOptionString("-val", M100Command.OptionType.TXT, Options.VAL, "Variable or value to set");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring? vname = null;
		if((vname = vals[Options.VAR]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		xtring?val = null;
		if((val = vals[Options.VAL]) == null) {
			cmds.vars.set(vname, null);
		} else {
			M100Variable mval = new M100Variable();
			mval.set(val);
			cmds.vars.set(vname, mval);
		}
		return 0;
	}
}
/* @} */
