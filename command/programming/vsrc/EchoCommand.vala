using aroop;
using shotodol;

/** \addtogroup standard_command
 *  @{
 */
internal class shotodol.EchoCommand : shotodol.M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("echo");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		etxt inp = etxt.stack_from_etxt(cmdstr);
		etxt token = etxt.EMPTY();
		LineAlign.next_token(&inp, &token); // second token
		pad.write(&inp);
		inp.destroy();
		bye(pad, true);
		return 0;
	}
}
/* @} */
