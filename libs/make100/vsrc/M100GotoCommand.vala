using aroop;
using shotodol;

/** \addtogroup standard_command
 *  @{
 */
internal class shotodol.M100GotoCommand : shotodol.M100Command {
	public M100GotoCommand() {
		estr prefix = estr.copy_static_string("goto");
		base(&prefix);
	}
	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) {
		estr inp = estr.stack_copy_deep(cmdstr);
		estr token = estr();
		LineAlign.next_token(&inp, &token); // second token
		int lineno = inp.to_int();
		inp.destroy();
		return lineno + FlowControl.GOTO_LINENO;
	}
}
/* @} */
