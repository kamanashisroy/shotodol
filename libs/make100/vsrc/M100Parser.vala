using aroop;
using shotodol;

public abstract class shotodol.M100Parser: Replicable {
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
	
	internal static void trim(etxt*src) {
		int ltrim = 0;
		int skippable = 0;
		int i;
		int len = src.length();
		for(i = 0; i < len; i++) {
			char x = src.char_at(i);
			if(x == '\t' || x == ' ' || x == '\r' || x == '\n') { // trim them
				skippable++;
			} else {
				if(skippable != 0)ltrim = skippable;
				skippable = 0;
			}
		}
		if(ltrim > 0)
			src.shift(ltrim);
		if(skippable > 0)
			src.shift((-skippable));
	}
	
	int next_token(etxt*src, etxt*next) {
		uint i = 0;
		int token_start = -1;
		int len = src.length();
		(*next) = etxt.share_etxt(src);
		for(i = 0; i < len; i++) {
			char x = src.char_at(i);
			if(x == '\t' || x == ' ' || x == '\r' || x == '\n') { // tokens
				if(token_start == -1) {
					continue;
				}
				next.trim_to_length(i);
				break;
			} else {
				token_start = (token_start == -1) ? (int)i : token_start;
				if(x == ':' || x == '(' || x == ')' || x == '$') { // punkchuation
					if(token_start == i) {
						next.trim_to_length(i+1);
					} else {
						next.trim_to_length(i);
					}
					break;
				}
			}
		}
		if(token_start >= 0) {
			next.shift(token_start);
		}
		src.shift((int)i);
		trim(next);
		return 0;
	}

	internal int func_comp(container<M100Function> can) {
		return 0;
	}

	M100Function? addFunction(etxt*name, etxt*proto) {
		container<M100Function>? can = funcs.search(name.get_hash(), func_comp);
		if(can != null) {
			return null;
		}
		M100Function ret = new M100Function(name, proto);
		funcs.add_container(ret, name.get_hash());
		return ret;
	}
	
	M100Function?current_function;	
	public void startParsing() {
		etxt dlg = etxt.from_static("Start parsing\n");
		Watchdog.watchit(5,0,0,0,&dlg);
		current_function = null;
	}
	public int parseLine(etxt*instr) {
		etxt dlg = etxt.stack(128);
		etxt inp = etxt.stack_from_etxt(instr);
		do {
			if(inp.char_at(0) == '\t') {
				Watchdog.watchit(5,0,0,0,&inp);
			}
			if(inp.char_at(0) == '\t' && current_function != null) {
				Watchdog.watchit(5,0,0,0,&inp);
				current_function.addCommand(&inp);
				break;
			}
			etxt token = etxt.EMPTY();
			next_token(&inp, &token);
			print("parsing tokens\n");
			if(token.is_empty()) {
				//current_function = null;
				break;
			}
			if(token.char_at(0) == '#') { // skip comment
				break;
			}
			etxt name = etxt.share_etxt(&token);
			next_token(&inp, &token);
			if(token.equals_static_string(":")) {
				// so this is a function
				current_function = addFunction(&name, instr);
				if(default_func == null) {
					default_func = current_function;
				}
				break;
			} else if(token.equals_static_string(":=") || token.equals_static_string("+=")  || token.equals_static_string("=")) {
				var x = new M100Statement(&name, &token, &inp);
				stmts[stmts.count_unsafe()] = (x);
				break;
			}
		} while(false);
		dlg.printf("current function is %s\n", current_function == null ? "null" : "not null");
		print(dlg.to_string());
		return 0;
	}

	public void endParsing() {
		etxt dlg = etxt.from_static("End parsing\n");
		Watchdog.watchit(5,0,0,0,&dlg);
		current_function = null;
	}
}
