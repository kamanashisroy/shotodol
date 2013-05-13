using aroop;
using shotodol;

internal class shotodol.ModuleCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("module");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		// TODO load module, show list of modules ..
		io.say_static("<Module command>");
		return 0;
	}
}
