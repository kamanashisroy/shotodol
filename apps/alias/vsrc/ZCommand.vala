using aroop;
using shotodol;

/** \addtogroup alias
 *  @{
 */

internal class shotodol.ZCommand : M100Command {
	internal HashTable<xtring,xtring> list;
	public ZCommand() {
		extring prefix = extring.set_static_string("z");
		base(&prefix);
		list = HashTable<xtring,xtring>(xtring.hCb,xtring.eCb);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineAlign.next_token(&inp, &token); 
		if(token.is_empty()) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		if(token.length() == 1) {
			LineAlign.next_token(&inp, &token); 
			if(token.is_empty()) {
				// TODO show list
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
			}
		} else {
			token.shift(1);
		}
		xtring?alias = new xtring.copy_deep(&token);
		xtring?action = list.getProperty(alias);
		if(action == null) {
			extring dlg = extring.set_static_string("no alias assigned at this name.\n");
			pad.write(&dlg);
			return 0;
		}
		extring dlg = extring.stack(128);
		dlg.printf("executing [%s]\n", action.fly().to_string());
		pad.write(&dlg);
		extring server = extring.set_static_string("command/server");
		extring reply = extring();
		PluginManager.swarm(&server, action, &reply);
		pad.write(&reply);
		return 0;
	}
}
/* @} */
