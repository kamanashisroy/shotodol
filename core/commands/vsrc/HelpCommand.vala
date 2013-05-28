using aroop;
using shotodol;

internal class shotodol.HelpCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("help");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Help command>");
		Command cmd = CommandServer.server.cmds.percept(cmdstr);
		cmd.desc(io, Command.CommandDescType.COMMAND_DESC_TITLE);
		
		return 0;
	}
}
