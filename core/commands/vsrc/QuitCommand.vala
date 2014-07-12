using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.QuitCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("quit");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) {
		txt quitEntry = new txt.from_static("onQuit");
		etxt output = etxt.EMPTY();
		Plugin.swarm(quitEntry, null, &output);
		if(!output.is_empty()) {
			pad.write(&output);
		}
		MainTurbine.quit();
		return 0;
	}
}
/* @} */
