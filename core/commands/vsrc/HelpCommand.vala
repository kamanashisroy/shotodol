using aroop;
using shotodol;

internal class shotodol.HelpCommand : Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("help");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Help command> -------------------------------------------------------\n");
		
		etxt inp = etxt.stack_from_etxt(cmdstr);
		int i = 0;
		for(i = 0; i < 32; i++) {
			etxt token = etxt.EMPTY();
			LineAlign.next_token(&inp, &token); // second token
			//token.zero_terminate();
			if(token.is_empty()) {
				break;
			}
			if(i == 0) {
				// skip command(help) argument
				continue;
			}
			etxt ntoken = etxt.stack_from_etxt(&token);
			ntoken.zero_terminate();
			Command? cmd = CommandServer.server.cmds.percept(&ntoken);
			if(cmd == null) {
				continue;
			}
			cmd.desc(io, Command.CommandDescType.COMMAND_DESC_FULL);
		}
		return 0;
	}
}
