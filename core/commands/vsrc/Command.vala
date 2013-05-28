using aroop;
using shotodol;

public class shotodol.Command : Replicable {
	public enum CommandDescType {
		COMMAND_DESC_TITLE,
		COMMAND_DESC_FULL,
	}
	//public etxt?cmdprefix;
	public virtual etxt*get_prefix() {
		return null;
	}
	public virtual int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		return 0;
	}
	public virtual int desc(StandardIO io, CommandDescType tp) {
		etxt x = etxt.stack(32);
		switch(tp) {
			case CommandDescType.COMMAND_DESC_TITLE:
			x.printf("%s\n", get_prefix().to_string());
			io.say_static(x.to_string());
			break;
			default:
			io.say_static("<Not available>\n");
			break;
		}
		return 0;
	}
}
