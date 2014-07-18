using aroop;
using shotodol;

/** \addtogroup standard_command
 *  @{
 */
internal class shotodol.EchoCommand : shotodol.M100Command {
	public EchoCommand() {
		extring prfx = extring.copy_static_string("echo");
		base(&prfx);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineAlign.next_token(&inp, &token); // second token
		pad.write(&inp);
		extring newLine = extring.set_static_string("\n");
		pad.write(&newLine);
		inp.destroy();
		return 0;
	}
}
/* @} */
