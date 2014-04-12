using aroop;

public class shotodol.M100Script : M100Parser {
	SearchableSet<M100Variable> vars;
	public M100Script() {
		base();
		vars = SearchableSet<M100Variable>();
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
		
		func = funcs.search(tg.get_hash(), null);
		return (func == null)?-1:0;
	}
	public txt? step() {
		etxt dlg = etxt.stack(128);
		if(func == null) {
			dlg.printf("no function is selected\n");
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),0,0,0,&dlg);
			return null;
		}
		if(expt == 0) {
			// TODO execute the statements
		}
		return func.getCommand(expt++);
	}
}
