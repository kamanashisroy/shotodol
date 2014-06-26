using aroop;
using shotodol;

/** \addtogroup control_command
 *  @{
 */
internal class shotodol.IfCommand : M100Command {
	etxt prfx;
	M100CommandSet set;
	public IfCommand(M100CommandSet gSet) {
		base();
		set = gSet;
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("if");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		bool inverse = false;
		etxt inp = etxt.stack_from_etxt(cmdstr);
		etxt token = etxt.EMPTY();
		LineAlign.next_token(&inp, &token); // if
		if(token.is_empty())
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");

		LineAlign.next_token(&inp, &token); // 0/1
		if(token.is_empty())
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");

		if(token.equals_string("not")) {
			inverse = true;
			LineAlign.next_token(&inp, &token); // 0/1
			if(token.is_empty())
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}

		// execute command inp ..
		uchar val = token.char_at(0);
		if((inverse && val == '0') || (!inverse && val == '1')) {
			while(inp.char_at(0) == ' ') inp.shift(1);
			set.act_on(&inp, pad);
		}
		return 0;
	}
}
/* @} */
