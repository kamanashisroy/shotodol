using aroop;
using shotodol;

internal class shotodol.QuitCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("quit");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Quit> -------------------------------------------------------\n");
		MainTurbine.quit();
		return 0;
	}
}
