using aroop;
using shotodol;

/**
 * \ingroup shotodol_library
 * \defgroup make100 Makefile scripting library
 * [Cohesion : Functional]
 */

/** \addtogroup make100
 *  @{
 */
public abstract class shotodol.M100Parser: Replicable {
	internal SearchableOPPFactory<M100Block> funcs;
	internal ArrayList<M100Statement> stmts;
	internal M100Block? default_func;
	protected M100Parser() {
		funcs = SearchableOPPFactory<M100Block>.for_type(32, 1, factory_flags.SWEEP_ON_UNREF | factory_flags.EXTENDED | factory_flags.SEARCHABLE | factory_flags.MEMORY_CLEAN);
		stmts = ArrayList<M100Statement>();
		default_func = null;
		scopeTree = ArrayList<M100Block>();
	}
	
	~M100Parser() {
		scopeTree.destroy();
		funcs.destroy();
		stmts.destroy();
	}
	
	internal static void trim(extring*src) {
		int ltrim = 0;
		int skippable = 0;
		int i;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
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
	
	protected int next_token(extring*src, extring*next) {
		uint i = 0;
		int token_start = -1;
		int len = src.length();
		next.rebuild_and_copy_shallow(src);
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			if(x == '\t' || x == ' ' || x == '\r' || x == '\n') { // tokens
				if(token_start == -1) {
					continue;
				}
				next.truncate(i);
				break;
			} else {
				token_start = (token_start == -1) ? (int)i : token_start;
				if(x == ':' || x == '(' || x == ')' || x == '$') { // punctuation
					if(token_start == i) {
						next.truncate(i+1);
					} else {
						next.truncate(i);
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

	M100Block? addBlock(extring*name, extring*proto, int lineno) {
		M100Block ret = funcs.alloc_full();
		ret.build(name, proto, lineno);
		ret.pin();
		return ret;
	}

	public void listBlocks(OutputStream pad, extring*delim) {
		Iterator<M100Block> bit = Iterator<M100Block>();
		funcs.iterator_full(&bit);
		while(bit.next()) {
			M100Block block = bit.get();
			//extring blockName = extring();
			//block.getNameAs(&blockName);
			//pad.write(&blockName);
			pad.write(block.name);
			pad.write(delim);
		}
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
		extring jumpcmd = extring.stack(12);
		jumpcmd.printf("\tgoto %d", lineno);
		scope.addCommand(&jumpcmd, lineno);
		return 0;
	}

	void gotoPreviousScope(int depth) {
		// sanity check
		if(depth <= 0) return;
		// get previous
		current_scope = scopeTree[depth];
		int i = 0;
		for(i = depth; i < scopeDepth; i++) scopeTree[i] = null;
		scopeDepth = depth;
		if(current_scope == null)
			gotoPreviousScope(depth - 1);
	}

	int addCommandHelper(extring*cmdstr, extring*instr, int lineno) {
		int depth = 0;
		while(cmdstr.char_at(1) == '\t') {
			cmdstr.shift(1);
			depth++;
		}
		if(current_scope == null) {
			current_scope = current_function;
			scopeTree[1] = current_scope;
		}
		if(depth < scopeDepth) {
			gotoPreviousScope(depth);
			if(current_scope == null)
				return -1;
		} else if(depth > scopeDepth){
			extring nm = extring.stack(32);
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

	void resetFunctionParser() {
		current_scope = null;
		int i = 1;
		for(;i<=scopeDepth;i++) {
			scopeTree[i] = null;
		}
		scopeDepth = 0;
	}

	public int parseLine(extring*instr) {
		extring inp = extring.stack_copy_deep(instr);
		do {
			if(inp.char_at(0) == '\t' && current_function != null) {
				addCommandHelper(&inp, instr, lineno);
				break;
			}
			extring token = extring();
			next_token(&inp, &token);
			if(token.is_empty()) {
				//current_function = null;
				break;
			}
			if(token.char_at(0) == '#') { // skip comment
				break;
			}
			extring name = extring.copy_shallow(&token);
			next_token(&inp, &token);
			if(token.equals_static_string(":")) {
				// so this is a function
				current_function = addBlock(&name, instr, lineno);
				resetFunctionParser();
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
