using aroop;
using shotodol;

/** \addtogroup standard_command
 *  @{
 */
internal class shotodol.EchoCommand : shotodol.M100Command {
	public EchoCommand() {
		estr prfx = estr.copy_static_string("echo");
		base(&prfx);
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) {
		estr inp = estr.stack_copy_deep(cmdstr);
		estr token = estr();
		LineAlign.next_token(&inp, &token); // second token
		pad.write(&inp);
		estr newLine = estr.set_static_string("\n");
		pad.write(&newLine);
		inp.destroy();
		return 0;
	}
}
/* @} */
