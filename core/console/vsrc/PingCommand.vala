using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.PingCommand : shotodol.M100Command {
	public PingCommand() {
		extring prefix = extring.set_static_string("ping");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring pong = extring.set_static_string("pong\r\n");
		pad.write(&pong);
		return 0;
	}
}
/* @} */
