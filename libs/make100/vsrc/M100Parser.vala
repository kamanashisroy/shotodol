using aroop;
using shotodol;

public abstract class M100Parser: Replicable {
	internal SearchableSet<M100Function> funcs;
	internal ArrayList<M100Statement> stmts;
	internal M100Function? default_func;
	protected M100Parser() {
		funcs = SearchableSet<M100Function>();
		stmts = ArrayList<M100Statement>();
		default_func = null;
	}
	
	~M100Parser() {
		funcs.destroy();
		stmts.destroy();
	}
	
	M100Function?current_function;	
	public int parseLine(etxt*instr) {
		etxt inp = etxt.stack_from_etxt(instr);
		etxt name = etxt.EMPTY();
		int i = 0;
		for(i = 0; i <= 1; i++) {
			etxt token = etxt.EMPTY();
			LineAlign.next_token(&inp, &token);
			if(token.is_empty()) {
				current_function = null;
				break;
			}
			if(current_function != null) {
				current_function.addCommand(instr);
				break;
			}
			switch(i) {
				case 0:
					name = etxt.share_etxt(&token);
				break;
				case 1:
					if(token.equals_static_string(":")) {
						// so this is a function
						current_function = new M100Function(&name, &inp);
						funcs.add_container(current_function, name.get_hash());
						if(default_func == null) {
							default_func = current_function;
						}
						break;
					} else if(token.equals_static_string(":=") || token.equals_static_string("+=")  || token.equals_static_string("=")) {
						var x = new M100Statement(&name, &token, &inp);
						stmts[stmts.count_unsafe()] = (x);
						break;
					}
				break;
				default:
				break;
			}
		}
		return 0;
	}
}
