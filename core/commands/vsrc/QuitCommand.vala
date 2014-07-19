using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.QuitCommand : M100Command {
	public QuitCommand() {
		var prefix = extring.set_static_string("quit");
		base(&prefix);
	}
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring quitEntry = extring.set_static_string("onQuit");
		extring output = extring();
		Plugin.swarm(&quitEntry, null, &output);
		if(!output.is_empty()) {
			pad.write(&output);
		}
		return 0;
	}
}
/* @} */
