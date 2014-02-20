using aroop;
using shotodol;

public abstract class shotodol.M100Parser: Replicable {
	internal SearchableFactory<M100Function> funcs;
	internal ArrayList<M100Statement> stmts;
	internal M100Function? default_func;
	protected M100Parser() {
		funcs = SearchableFactory<M100Function>.for_type();
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

	M100Function? addFunction(etxt*name, etxt*proto) {
		M100Function ret = funcs.alloc_full();
		ret.build(name, proto);
		ret.pin();
		return ret;
	}
	
	M100Function?current_function;	
	public void startParsing() {
		current_function = null;
	}
	public int parseLine(etxt*instr) {
		etxt inp = etxt.stack_from_etxt(instr);
		do {
			if(inp.char_at(0) == '\t' && current_function != null) {
				current_function.addCommand(&inp);
				break;
			}
			etxt token = etxt.EMPTY();
			next_token(&inp, &token);
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
		return 0;
	}

	public void endParsing() {
		current_function = null;
	}
}
