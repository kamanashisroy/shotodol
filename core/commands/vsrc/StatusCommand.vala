using aroop;
using shotodol;

/** \addtogroup commandserver
 *  @{
 */
internal class shotodol.StatusCommand : M100Command {
	public StatusCommand() {
		var prefix = extring.copy_static_string("status");
		base(&prefix);
	}
	public override int act_on(/*ArrayList<xtring> tokens*/extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring output = extring.stack(512);
		extring status = extring.set_static_string("status");
		PluginManager.swarm(&status, cmdstr, &output);
		pad.write(&output);
		return 0;
	}

	public override int desc(M100Command.CommandDescType tp, OutputStream pad) {
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_FULL:
			extring x = extring.stack(512); // allocate memory in stack
			x.concat_string("\tstatus command shows advertised status.\n");
			x.concat_string("EXAMPLE:\n");
			x.concat_string("\t`status`.\n");
			pad.write(&x);
			break;
		}
		return base.desc(tp, pad);
	}
}
/* @} */
