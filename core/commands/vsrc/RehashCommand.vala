using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.RehashCommand : M100Command {
	etxt prfx;
	unowned M100CommandSet cmds; // avoid cyclic reference
	public RehashCommand(M100CommandSet gCmds) {
		cmds = gCmds;
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("rehash");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		//cmds.rehash();
		txt rehash = new txt.from_static("rehash");
		Plugin.swarm(rehash, null, null);
		return 0;
	}
}
/* @} */
