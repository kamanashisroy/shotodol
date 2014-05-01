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
		etxt again = etxt.from_static("-a");
		etxt again_help = etxt.from_static("Try the command again");
		addOption(&again, M100Command.OptionType.INT, Options.AGAIN, &again_help);
		etxt glide = etxt.from_static("-gl");
		etxt glide_help = etxt.from_static("Duration to glide(become inactive), 0 by default");
		addOption(&glide, M100Command.OptionType.INT, Options.GLIDE, &glide_help);
		etxt list = etxt.from_static("-l");
		etxt list_help = etxt.from_static("List commands from history");
		addOption(&list, M100Command.OptionType.NONE, Options.LIST, &list_help);
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
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		int duration = 1000;
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL,pad);
			bye(pad, false);
			return 0;
		}
		container<txt>? mod;
		if((mod = vals.search(Options.AGAIN, match_all)) != null) {
			int index = mod.get().to_int();
			txt?again = sp.getHistory(index);
			if(again == null) {
				bye(pad, false);
				return 0;
			}
			cmdSet.act_on(again, pad);
			bye(pad, true);
			return 0;
		}
		if((mod = vals.search(Options.LIST, match_all)) != null) {
			sp.showHistoryFull();
			bye(pad, true);
			return 0;
		}
		if((mod = vals.search(Options.GLIDE, match_all)) != null) {
			duration = mod.get().to_int();
		}
		sp.glide(duration);
		bye(pad, true);
		return 0;
	}
}
/* @} */
