using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.SetVariableCommand : M100Command {
	etxt prfx;
	enum Options {
		VAR = 1,
		VAL,
	}
	public SetVariableCommand() {
		base();
		addOptionString("-var", M100Command.OptionType.TXT, Options.VAR, "Destination variable name");
		addOptionString("-val", M100Command.OptionType.TXT, Options.VAL, "Variable or value to set");
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("set");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt? var = null;
		if((var = vals[Options.VAR]) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		txt?val = null;
		if((val = vals[Options.VAL]) == null) {
			cmds.vars.set(var, null);
		} else {
			M100Variable mval = new M100Variable();
			mval.set(val);
			cmds.vars.set(var, mval);
		}
		return 0;
	}
}
/* @} */
