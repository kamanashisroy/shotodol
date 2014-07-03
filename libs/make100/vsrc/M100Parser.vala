using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup make100 Makefile parser code(make100)
 */

/** \addtogroup make100
 *  @{
 */
public abstract class shotodol.M100Parser: Replicable {
	internal SearchableFactory<M100Block> funcs;
	internal ArrayList<M100Statement> stmts;
	internal M100Block? default_func;
	protected M100Parser() {
		funcs = SearchableFactory<M100Block>.for_type(32, 1, factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
		stmts = ArrayList<M100Statement>();
		default_func = null;
		scopeTree = ArrayList<M100Block>();
	}
	
	~M100Parser() {
		scopeTree.destroy();
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
	
	protected int next_token(etxt*src, etxt*next) {
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
				if(x == ':' || x == '(' || x == ')' || x == '$') { // punctuation
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

	M100Block? addBlock(etxt*name, etxt*proto, int lineno) {
		M100Block ret = funcs.alloc_full();
		ret.build(name, proto, lineno);
		ret.pin();
		return ret;
	}
	
	M100Block?current_function;	
	M100Block?current_scope;
	int scopeDepth;
	int lineno;
	ArrayList<M100Block>scopeTree;
	public void startParsing() {
		current_function = null;
		current_scope = null;
		scopeDepth = 0;
		lineno = 0;
		scopeTree.destroy();
		scopeTree = ArrayList<M100Block>();
	}

	int addJumpTo(M100Block?scope, int depth, int lineno) {
		etxt jumpcmd = etxt.stack(12);
		jumpcmd.printf("\tgoto %d", lineno);
		scope.addCommand(&jumpcmd, lineno);
		return 0;
	}

	int addCommandHelper(etxt*cmdstr, etxt*instr, int lineno) {
		int depth = 0;
		while(cmdstr.char_at(1) == '\t') {
			cmdstr.shift(1);
			depth++;
		}
		if(current_scope == null) {
			current_scope = current_function;
			scopeTree[scopeDepth] = current_scope;
		}
		if(depth < scopeDepth) {
			current_scope = scopeTree[depth];
		} else if(depth > scopeDepth){
			etxt nm = etxt.stack(32);
			nm.printf("____scope____%d", lineno);
			M100Block?prev = current_scope;
			current_scope = addBlock(&nm, instr, lineno);
			scopeTree[depth] = current_scope;
			prev.addBlock(current_scope, lineno);
			addJumpTo(prev, depth, lineno);
		}
		scopeDepth = depth;
		current_scope.addCommand(cmdstr, lineno);
		return 0;
	}

	public int parseLine(etxt*instr) {
		etxt inp = etxt.stack_from_etxt(instr);
		do {
			if(inp.char_at(0) == '\t' && current_function != null) {
				addCommandHelper(&inp, instr, lineno);
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
				current_function = addBlock(&name, instr, lineno);
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
		lineno++;
		return 0;
	}

	public void endParsing() {
		current_function = null;
		current_scope = null;
		scopeDepth = 0;
		lineno = 0;
		scopeTree.destroy();
	}
}
/** @}*/
