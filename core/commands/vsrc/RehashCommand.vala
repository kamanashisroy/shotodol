using aroop;
using shotodol;

/** \addtogroup commandserver
 *  @{
 */
internal class shotodol.RehashCommand : M100Command {
	public RehashCommand() {
		var prefix = extring.copy_static_string("rehash");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring rehash = extring.set_static_string("rehash");
		PluginManager.swarm(&rehash, null, null);
		return 0;
	}
}
/* @} */
