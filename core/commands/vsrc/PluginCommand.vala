using aroop;
using shotodol;

/** \addtogroup commandserver
 *  @{
 */
internal class shotodol.PluginCommand : M100Command {
	enum Options {
		EXTENSION = 1,
		ACT,
	}
	public PluginCommand() {
		var prefix = extring.copy_static_string("plugin");
		base(&prefix);
		addOptionString("-x", M100Command.OptionType.TXT, Options.EXTENSION, "Choose an extension"); 
		addOptionString("-act", M100Command.OptionType.NONE, Options.ACT, "Dispatch the extension command"); 
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?ex = vals[Options.EXTENSION];
		if(ex == null) {
			PluginManager.list(pad);
			return 0;
		}
		int count = 0;
		bool dispatch = vals[Options.ACT] != null;
		PluginManager.acceptVisitor(ex, (x) => {
			count++;
			x.desc(pad);
		});
		if(dispatch) PluginManager.swarm(ex, null, null);
		extring dlg = extring.stack(128);
		dlg.printf("There are %d extensions in %s directory\n", count, ex.fly().to_string());
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
