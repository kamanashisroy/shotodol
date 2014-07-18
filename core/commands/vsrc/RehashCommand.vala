using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.RehashCommand : M100Command {
	public RehashCommand() {
		extring prefix = extring.copy_static_string("rehash");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring rehash = extring.set_static_string("rehash");
		Plugin.swarm(&rehash, null, null);
		return 0;
	}
}
/* @} */
