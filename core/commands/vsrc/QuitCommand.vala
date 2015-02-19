using aroop;
using shotodol;

/** \addtogroup commandserver
 *  @{
 */
internal class shotodol.QuitCommand : M100Command {
	enum Options {
		SOFT = 1,
	}
	public QuitCommand() {
		var prefix = extring.set_static_string("quit");
		base(&prefix);
		addOptionString("-soft", M100Command.OptionType.NONE, Options.SOFT, "It calls the onQuit hook");
	}
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?sft = vals[Options.SOFT];
		extring quitEntry = extring.set_static_string("onQuit/soft");
		extring output = extring();
		PluginManager.swarm(&quitEntry, null, &output);
		if(!output.is_empty()) {
			pad.write(&output);
		}
		if(sft != null) return 0;
		quitEntry.rebuild_and_set_static_string("onQuit");
		PluginManager.swarm(&quitEntry, null, &output);
		if(!output.is_empty()) {
			pad.write(&output);
		}
		return 0;
	}
}
/* @} */
