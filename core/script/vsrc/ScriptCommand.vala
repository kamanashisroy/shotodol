using aroop;
using shotodol;
using shotodol_lua;

/**
 * \ingroup core
 * \defgroup script A script plugin(lua)
 */

/** \addtogroup script
 *  @{
 */
#if LUA_LIB
internal class ScriptCommand : M100Command {
	enum Options {
		TARGET = 1,
		FILE,
	}
	CompositeExtension ex;
	unowned Module sourceModule;
	public ScriptCommand(CompositeExtension container, Module mod) {
		extring prefix = extring.set_static_string("script");
		base(&prefix);
		addOptionString("-t", M100Command.OptionType.TXT, Options.TARGET, "target name");
		addOptionString("-f", M100Command.OptionType.TXT, Options.FILE, "script file name/path"); 
		script = null;
		ex = container;
		sourceModule = mod;
	}

	unowned LuaStack? script;
	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?fn = vals[Options.FILE];
		xtring?tgt = vals[Options.TARGET];
		if(fn == null && tgt == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		
		if(fn != null) {
			script = LuaStack.create();
			if(script.loadFile(fn.fly().to_string()) != 0) {
				extring dlg = extring.set_static_string("Failed to load file\n");
				pad.write(&dlg);
				script = null;
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Could not open lua script file");
			} else {
				script.call(0,0,0);
			}
		}
		if(script == null)
			return 0;
		if(tgt == null) {
			tgt = new xtring.set_static_string("rehash");
		}
		script.setOutputStream(pad);
		extring dlg = extring.stack(128);
		dlg.printf("target:[%s]\n", tgt.fly().to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		script.getField(script.GLOBAL_SPACE, tgt.fly().to_string());
		script.call(0,1,0);
		if(script.isString(-1)) {
			extring scriptout = extring();
			script.getXtringAs(&scriptout, -1);
			pad.write(&scriptout);
			if(tgt.fly().equals_static_string("rehash")) {
				registerHookExtensions(fn, &scriptout);
			}
		}
		script.pop(1);
		return 0;
	}
	void registerHookExtensions(extring*fn, extring*funcs) {
		extring token = extring();
		extring inp = extring.stack_copy_deep(funcs);
		while(true) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			print("registering %s hook\n", token.to_string());
			ex.register(&token, new LuaExtension(script, fn, &token, sourceModule));
		}
	}
}
#endif
/* @} */
