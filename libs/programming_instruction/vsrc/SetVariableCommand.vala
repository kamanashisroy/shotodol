using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.SetVariableCommand : M100Command {
	etxt prfx;
	unowned M100CommandSet cmds;
	enum Options {
		VAR = 1,
		VAL,
	}
	public SetVariableCommand(M100CommandSet gCmds) {
		base();
		cmds = gCmds;
		etxt var = etxt.from_static("-var");
		etxt var_help = etxt.from_static("Destination variable name");
		etxt val = etxt.from_static("-val");
		etxt val_help = etxt.from_static("variable or value to set");
		addOption(&var, M100Command.OptionType.TXT, Options.VAR, &var_help);
		addOption(&val, M100Command.OptionType.TXT, Options.VAL, &val_help);
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("set");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			bye(pad, false);
			return 0;
		}
		container<txt>? mod;
		mod = vals.search(Options.VAR, match_all);
		if(mod == null) {
			bye(pad, false);
			return 0;
		}
		txt var = mod.get();
		mod = vals.search(Options.VAL, match_all);
		if(mod == null) {
			cmds.vars.set(var, null);
		} else {
			txt val = mod.get();
			M100Variable mval = new M100Variable();
			mval.set(val);
			cmds.vars.set(var, mval);
		}
		bye(pad, true);
		return 0;
	}
}
/* @} */
