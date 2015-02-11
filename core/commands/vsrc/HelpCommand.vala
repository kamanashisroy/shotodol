using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.HelpCommand : M100Command {
	public HelpCommand() {
		var prefix = extring.copy_static_string("help");
		base(&prefix);
	}
	public override int act_on(/*ArrayList<xtring> tokens*/extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring inp = extring.stack_copy_deep(cmdstr);
		int i = 0;
		for(i = 0; i < 32; i++) {
			extring token = extring();
			LineAlign.next_token(&inp, &token); // second token
			//token.zero_terminate();
			if(token.is_empty()) {
				if(i == 1) {
					CommandModule.server.cmds.listCommands(pad);
				}
				break;
			}
			if(i == 0) {
				// skip command(help) argument
				continue;
			}
			extring ntoken = extring.stack_copy_deep(&token);
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
