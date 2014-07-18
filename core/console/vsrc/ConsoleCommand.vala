using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.ConsoleCommand : shotodol.M100Command {
	enum Options {
		LIST = 1,
		AGAIN,
		GLIDE,
	}
	ConsoleHistory sp;
	public ConsoleCommand(ConsoleHistory gSp) {
		extring prefix = extring.set_static_string("shell");
		base(&prefix);
		addOptionString("-a", M100Command.OptionType.INT, Options.AGAIN, "Try the command again");
		addOptionString("-gl", M100Command.OptionType.INT, Options.GLIDE, "Duration to glide(become inactive), 0 by default");
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "List commands from history");
		sp = gSp;
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int duration = 1000;
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring? arg;
		if((arg = vals[Options.AGAIN]) != null) {
			int index = arg.ecast().to_int();
			xtring?again = sp.getHistory(index);
			if(again == null) {
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
			}
			cmds.act_on(again, pad, null);
			return 0;
		}
		if(vals[Options.LIST] != null) {
			sp.showHistoryFull();
		}
		if((arg = vals[Options.GLIDE]) != null) {
			duration = arg.ecast().to_int();
		}
		sp.glide(duration);
		return 0;
	}
}
/* @} */
