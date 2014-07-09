using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.ConsoleCommand : shotodol.M100Command {
	etxt prfx;
	enum Options {
		LIST = 1,
		AGAIN,
		GLIDE,
	}
	ConsoleHistory sp;
	unowned M100CommandSet cmdSet;
	public ConsoleCommand(M100CommandSet gCmdSet) {
		base();
		cmdSet = gCmdSet;
		addOptionString("-a", M100Command.OptionType.INT, Options.AGAIN, "Try the command again");
		addOptionString("-gl", M100Command.OptionType.INT, Options.GLIDE, "Duration to glide(become inactive), 0 by default");
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "List commands from history");
		sp = new ConsoleHistory();
		MainTurbine.gearup(sp);
	}

	~ConsoleCommand() {
		MainTurbine.geardown(sp);
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("shell");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		int duration = 1000;
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt? arg;
		if((arg = vals[Options.AGAIN]) != null) {
			int index = arg.to_int();
			txt?again = sp.getHistory(index);
			if(again == null) {
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
			}
			cmdSet.act_on(again, pad, null);
			return 0;
		}
		if(vals[Options.LIST] != null) {
			sp.showHistoryFull();
		}
		if((arg = vals[Options.GLIDE]) != null) {
			duration = arg.to_int();
		}
		sp.glide(duration);
		return 0;
	}
}
/* @} */
