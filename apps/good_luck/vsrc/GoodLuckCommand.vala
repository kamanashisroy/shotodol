using aroop;
using shotodol;

/** \addtogroup good_luck
 *  @{
 */

internal class shotodol.GoodLuckCommand : M100Command {
	enum Options {
		NAME = 1,
	}
	public GoodLuckCommand() {
		extring prefix = extring.set_static_string("goodluck");
		base(&prefix);
		addOptionString("-name", M100Command.OptionType.TXT, Options.NAME, "Your name");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		extring dlg = extring.stack(128);
		dlg.concat_string("Good luck ");
		if(vals[Options.NAME] != null) {
			dlg.concat(vals[Options.NAME]);
		}
		dlg.concat_char('\n');
		dlg.concat_string("Have nice time with shotodol.\n");
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
