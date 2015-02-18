using aroop;
using shotodol;

/** \addtogroup alias
 *  @{
 */

internal class shotodol.AliasCommand : M100Command {
	internal ZCommand acmd;
	public AliasCommand() {
		extring prefix = extring.set_static_string("alias");
		base(&prefix);
		acmd = new ZCommand();
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineAlign.next_token(&inp, &token); 
		if(token.is_empty()) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		LineAlign.next_token(&inp, &token); 
		if(token.is_empty()) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		inp.shift(1);
		xtring alias = new xtring.copy_deep(&token);
		xtring action = new xtring.copy_deep(&inp);
		acmd.list.set(alias, action);
		extring dlg = extring.stack(128);
		dlg.printf("[z%s] is alias of [%s]\n", alias.fly().to_string(), action.fly().to_string());
		pad.write(&dlg);
		return 0;
	}

	public override int desc(M100Command.CommandDescType tp, OutputStream pad) {
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_FULL:
			extring x = extring.stack(512);
			x.concat_string("\tAlias command creates alias for fully argumented command.\n");
			x.concat_string("EXAMPLE:\n");
			x.concat_string("\t`alias w watchdog -l 100 -tag 55` will create alias named `zw` stands for `watchdog -l 100 -tag 55`.\n");
			pad.write(&x);
			break;
		}
		return base.desc(tp, pad);
	}
}
/* @} */
