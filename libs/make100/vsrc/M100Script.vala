using aroop;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Script : M100Parser {
	SearchableSet<M100Variable> vars;
	public M100Script() {
		base();
		vars = SearchableSet<M100Variable>();
		args = ArrayList<txt?>();
	}
	
	~M100Script() {
		vars.destroy();
	}
	int expt;
	M100Function? func;
	txt?current_target;
	ArrayList<txt?>args;
	public int target(etxt*tg) {
		expt = 0;
		if(tg.is_empty_magical()) {
			func = default_func;
			return 0;
		} 
		current_target = new txt.memcopy_etxt(tg);
		etxt inp = etxt.stack_from_etxt(current_target);
		int argc = 0;
		do {
			etxt token = etxt.EMPTY();
			next_token(&inp, &token);
			if(token.is_empty()) {
				//current_function = null;
				break;
			}
			args[argc] = new txt.memcopy_etxt(&token);
			argc++;
		} while(true);
		
		func = funcs.search(tg.get_hash(), null);
		return (func == null)?-1:0;
	}
	public txt? step() {
		etxt dlg = etxt.stack(128);
		if(func == null) {
			dlg.printf("no function is selected\n");
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(), 10,0,0,0,&dlg);
			return null;
		}
		if(expt == 0) {
			// TODO execute the statements
		}
		txt?cmd = func.getCommand(expt++);
		if(current_target == null || cmd == null) {
			return cmd;
		}
		// rewrite the command with args
		int rewritelen = cmd.length();
		rewritelen+= current_target.length();
		txt?arg1 = args.get(0);
		core.assert(arg1 != null);
		etxt rewritecmd = etxt.stack(rewritelen);
		char p = '\0';
		int i;
		int len = cmd.length();
		for(i = 0; i < len; i++) {
			char x = cmd.char_at(i);
			if(p == '$' && (x - '0') >= 0 && (x - '0') <= 9 ) { // variable
				x = x - '0';
				txt?arg = args.get(x);
				if(arg != null) {
					rewritecmd.concat(arg);
				} else {
					// do nothing
				}
			} else if(x == '$') {
				// do nothing ..
			} else {
				rewritecmd.concat_char(x);
			}
			p = x;
		}
		return new txt.memcopy_etxt(&rewritecmd);
	}
}
/** @}*/
