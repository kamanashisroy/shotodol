using aroop;
using shotodol;

internal class RulesCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("make");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("We are working ..");
		return 0;
	}
}
