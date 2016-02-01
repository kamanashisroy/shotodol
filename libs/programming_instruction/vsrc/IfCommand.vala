using aroop;
using shotodol;

/** \addtogroup control_command
 *  @{
 */
internal class shotodol.IfCommand : M100Command {
	public IfCommand() {
		extring prfx = extring.copy_static_string("if");
		base(&prfx);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		bool inverse = false;
		extring inp = extring.stack_copy_deep(cmdstr);
		extring token = extring();
		LineExpression.next_token(&inp, &token); // if
		if(token.is_empty())
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");

		LineExpression.next_token(&inp, &token); // 0/1
		if(token.is_empty())
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");

		if(token.equals_string("not") || token.equals_string("!")) {
			inverse = true;
			LineExpression.next_token(&inp, &token); // 0/1
			if(token.is_empty())
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}

		bool inlineif = false;
		// execute command inp ..
		uchar val = token.char_at(0);
		while(inp.char_at(0) == ' ') inp.shift(1);
		if(inp.length() != 0) { 
			inlineif = true;
		}
		bool cond = (inverse && val == '0') || (!inverse && val == '1');
		if(cond) {
			if(inlineif)cmds.act_on(&inp, pad, null);
		}
		return (!inlineif && !cond)?FlowControl.SKIP_BLOCK:FlowControl.KEEP_GOING;
	}
}
/* @} */
