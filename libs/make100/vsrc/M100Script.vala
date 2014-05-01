using aroop;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Script : M100Parser {
	public M100Script() {
		base();
		args = HashTable<M100Variable?>();
	}
	
	~M100Script() {
	}
	int expt;
	M100Function? func;
	txt?current_target;
	HashTable<M100Variable?>args;
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
			M100Variable varVal = new M100Variable();
			varVal.set(&token);
			txt varName = new txt.memcopy("0", 4);
			varName.printf("%d", argc);
			args.set(varName, varVal);
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
#if false
		return M100Command.rewrite(cmd, &args);
#else
		return cmd;
#endif
	}
}
/** @}*/
