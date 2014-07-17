using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.RehashCommand : M100Command {
	public RehashCommand() {
		estr prefix = estr.copy_static_string("rehash");
		base(&prefix);
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		estr rehash = estr.set_static_string("rehash");
		Plugin.swarm(&rehash, null, null);
		return 0;
	}
}
/* @} */
