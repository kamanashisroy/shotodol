using aroop;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Script : M100Parser {
	ArrayList<M100VirtualMachineFrame>stack;
	OPPFactory<M100VirtualMachineFrame> memory;
	M100VirtualMachineFrame? scope;
	M100Block? func;
	int depth;
	public M100Script() {
		base();
		args = HashTable<xtring,M100Variable?>(xtring.hCb,xtring.eCb);
		scope = null;
		depth = 0;
		memory = OPPFactory<M100VirtualMachineFrame>.for_type(4, 0, factory_flags.MEMORY_CLEAN);
		stack.destroy();
	}
	
	~M100Script() {
		memory.destroy();
		stack.destroy();
	}
	xtring?current_target;
	HashTable<xtring,M100Variable?>args;
	public int target(extring*tg) {
		depth = -1;
		if(tg.is_empty_magical()) {
			func = default_func;
			return 0;
		} 
		current_target = new xtring.copy_on_demand(tg);
		extring inp = extring.stack_copy_deep(current_target);
		int argc = 0;
		do {
			extring token = extring();
			next_token(&inp, &token);
			if(token.is_empty()) {
				//current_function = null;
				break;
			}
			M100Variable varVal = new M100Variable();
			varVal.set(&token);
			xtring varName = new xtring.copy_content("0", 4);
			varName.fly().printf("%d", argc);
			args.set(varName, varVal);
			argc++;
		} while(true);
		
		func = funcs.search(tg.getStringHash(), null);
		return (func == null)?-1:0;
	}

	public int gotoLine(int lineno) {
		depth++;
		M100VirtualMachineFrame?prev = scope;
		M100Block?cur = prev.getBlockAt(lineno);
		if(cur == null) return -1;
		scope = memory.alloc_full();
		scope.build(cur);
		stack.set(depth, scope);
		return 0;
	}

	public xtring? step() {
		if(func == null) {
			Watchdog.watchit_string(core.sourceFileName(), core.sourceLineNo(), 10,0,0,0, "no function is selected\n");
			return null;
		}
		if(depth == -1) {
			// TODO execute the statements
			stack = ArrayList<M100VirtualMachineFrame>();
			scope = memory.alloc_full();
			scope.build(func);
			depth = 0;
			stack[depth] = scope;
		}
		xtring?cmd = scope.nextCommand();
		if(current_target == null || cmd == null) {
			if(depth > 0) {
				depth--;
				scope = stack[depth];
				return step();
			}
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
