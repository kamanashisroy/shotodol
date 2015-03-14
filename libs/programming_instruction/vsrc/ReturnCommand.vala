using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.ReturnCommand : M100Command {
	xtring ret_val;
	public ReturnCommand() {
		extring prfx = extring.copy_static_string("return");
		base(&prfx);
		ret_val = new xtring.copy_static_string("__ret_val");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineAlign.next_token(&inp, &token); // second token
		inp.shift(1);
		if(inp.is_empty()) {
			cmds.vars.set(ret_val, null);
		} else {
			M100Variable mval = new M100Variable();
			mval.set(&inp);
			cmds.vars.set(ret_val, mval);
		}
		return 0;
	}
}
/* @} */
