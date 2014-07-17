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
		estr prefix = estr.copy_static_string("help");
		base(&prefix);
		addOptionString("-x", M100Command.OptionType.TXT, Options.DESC, "Describe an extension"); 
		addOptionString("-act", M100Command.OptionType.NONE, Options.ACT, "Dispatch the extension command"); 
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<str> vals = ArrayList<str>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		str?ex = vals[Options.DESC];
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
		//Plugin.list(pad);
		estr dlg = estr.stack(128);
		dlg.printf("There are %d extensions in this catagory\n", count);
		pad.write(&dlg);
		return 0;
	}
}
/* @} */
