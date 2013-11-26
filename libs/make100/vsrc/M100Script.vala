using aroop;

public class shotodol.M100Script : M100Parser {
	SearchableSet<M100Variable> vars;
	public M100Script() {
		base();
		vars = SearchableSet<M100Variable>();
	}
	
	internal int func_comp(container<M100Function> can) {
		return 0;
	}

	
	~M100Script() {
		vars.destroy();
	}
	int expt;
	M100Function? func;
	public int target(etxt*tg) {
		expt = 0;
		if(tg.is_empty_magical()) {
			func = default_func;
			return 0;
		} 
		
		container<M100Function>? can = funcs.search(tg.get_hash(), func_comp/*comp.comp*/);
		if(can == null) {
			return -1;
		}
		func = can.get();
		return 0;
	}
	public txt? step() {
		if(func == null) {
			return null;
		}
		if(expt == 0) {
			// TODO execute the statements
		}
		return func.getCommand(expt++);
	}
}
