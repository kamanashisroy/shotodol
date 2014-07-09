using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.PluginCommand : M100Command {
	etxt prfx;
	enum Options {
		LIST = 1,
	}
	public PluginCommand() {
		base();
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "List all modules"); 
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("plugin");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		print("Todo dump each extension information.\n");
		//Plugin.x.list(pad);
		return 0;
	}
}
/* @} */
