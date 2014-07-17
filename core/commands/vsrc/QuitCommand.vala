using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.QuitCommand : M100Command {
	public QuitCommand() {
		estr prefix = estr.set_static_string("quit");
		base(&prefix);
	}
	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) {
		estr quitEntry = estr.set_static_string("onQuit");
		estr output = estr();
		Plugin.swarm(&quitEntry, null, &output);
		if(!output.is_empty()) {
			pad.write(&output);
		}
		return 0;
	}
}
/* @} */
