using aroop;
using shotodol;

internal class shotodol.QuitCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("quit");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		MainTurbine.quit();
		return 0;
	}
}
