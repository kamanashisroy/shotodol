using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.ForkCommand : shotodol.M100Command {
	public ForkCommand() {
		extring prefix = extring.set_static_string("fork");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		forkHook(null, null);
		return 0;
	}

	internal int forkHook(extring*msg, extring*output) {
		// fork and return the pipe ..
		//if(msg != null && msg.contains_static_string("core"))
		fork();
		return 0;
	}
}
/* @} */
