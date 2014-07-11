using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.PluginCommand : M100Command {
	etxt prfx;
	enum Options {
		DESC = 1,
		ACT,
	}
	public PluginCommand() {
		base();
		addOptionString("-d", M100Command.OptionType.TXT, Options.DESC, "Describe an extension"); 
		addOptionString("-act", M100Command.OptionType.NONE, Options.ACT, "Dispatch the extension command"); 
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("plugin");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		Plugin.list(pad);
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?ex = vals[Options.DESC];
		if(ex == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		bool dispatch = vals[Options.ACT] != null;
		Extension?root = Plugin.get(ex);
		while(root != null) {
			root.desc(pad);
			if(dispatch) root.act(null,null);
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
}
/* @} */
