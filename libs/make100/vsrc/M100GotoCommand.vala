using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal class shotodol.M100GotoCommand : shotodol.M100Command {
	public M100GotoCommand() {
		extring prefix = extring.copy_static_string("goto");
		base(&prefix);
	}
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineExpression.next_token(&inp, &token); // second token
		int lineno = inp.to_int();
		inp.destroy();
		return lineno + FlowControl.GOTO_LINENO;
	}
}
/* @} */
