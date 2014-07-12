using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.HelpCommand : M100Command {
	etxt prfx;
	public override etxt*get_prefix() {
		prfx = etxt.from_static("help");
		return &prfx;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, OutputStream pad, M100CommandSet cmds) {
		etxt inp = etxt.stack_from_etxt(cmdstr);
		int i = 0;
		for(i = 0; i < 32; i++) {
			etxt token = etxt.EMPTY();
			LineAlign.next_token(&inp, &token); // second token
			//token.zero_terminate();
			if(token.is_empty()) {
				if(i == 1) {
					CommandModule.server.cmds.list(pad);
				}
				break;
			}
			if(i == 0) {
				// skip command(help) argument
				continue;
			}
			etxt ntoken = etxt.stack_from_etxt(&token);
			ntoken.zero_terminate();
			M100Command? cmd = CommandModule.server.cmds.percept(&ntoken);
			if(cmd == null) {
				continue;
			}
			cmd.desc(M100Command.CommandDescType.COMMAND_DESC_FULL, pad);
		}
		return 0;
	}
}
/* @} */
