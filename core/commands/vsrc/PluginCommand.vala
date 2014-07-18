using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.PluginCommand : M100Command {
	enum Options {
		DESC = 1,
		ACT,
	}
	public PluginCommand() {
		extring prefix = extring.copy_static_string("help");
		base(&prefix);
		addOptionString("-x", M100Command.OptionType.TXT, Options.DESC, "Describe an extension"); 
		addOptionString("-act", M100Command.OptionType.NONE, Options.ACT, "Dispatch the extension command"); 
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?ex = vals[Options.DESC];
		if(ex == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		int count = 0;
		bool dispatch = vals[Options.ACT] != null;
		Extension?root = Plugin.get(ex);
		while(root != null) {
			count++;
			root.desc(pad);
			if(dispatch) root.act(null,null);
			Extension?next = root.getNext();
			root = next;
		}
		extring dlg = extring.stack(128);
		dlg.printf("There are %d extensions in %s directory\n", count, ex.ecast().to_string());
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
