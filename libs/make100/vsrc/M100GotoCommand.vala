using aroop;
using shotodol;

/** \addtogroup standard_command
 *  @{
 */
internal class shotodol.M100GotoCommand : shotodol.M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("goto");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) {
		etxt inp = etxt.stack_from_etxt(cmdstr);
		etxt token = etxt.EMPTY();
		LineAlign.next_token(&inp, &token); // second token
		int lineno = inp.to_int();
		inp.destroy();
		return lineno + FlowControl.GOTO_LINENO;
	}
}
/* @} */
