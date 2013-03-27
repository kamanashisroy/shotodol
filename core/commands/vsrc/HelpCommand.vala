using aroop;
using shotodol;

internal class shotodol.HelpCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("help");
		return &prfx;
	}
	public virtual int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Help command>");
		return 0;
	}
}
