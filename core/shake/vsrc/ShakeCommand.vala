using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup shake Shake scripting support.
 */

/** \addtogroup shake
 *  @{
 */
internal class ShakeCommand : M100Command {
	enum Options {
		TARGET = 1,
		FILE,
	}
	internal CompositeExtension?ext;
	unowned DynamicModule?sourceModule;
	public ShakeCommand(DynamicModule?mod) {
		extring prefix = extring.set_static_string("shake");
		base(&prefix);
		addOptionString("-t", M100Command.OptionType.TXT, Options.TARGET, "target name");
		addOptionString("-f", M100Command.OptionType.TXT, Options.FILE, "shake file name/path"); 
		script = null;
		ext = new CompositeExtension(mod);
		sourceModule = mod;
	}

	M100Script? script;
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
			try {
				FileInputStream f = new FileInputStream.from_file(fn);
				LineInputStream lis = new LineInputStream(f);
				script = new M100Script();
				script.startParsing();
				while(true) {
					try {
						extring buf = extring.stack(1024);
						if(lis.read(&buf) == 0) {
							break;
						}
						script.parseLine(&buf);
					} catch(IOStreamError.InputStreamError e) {
						break;
					}
				}
				lis.close();
				f.close();
				script.endParsing();
			} catch (IOStreamError.FileInputStreamError e) {
			}
		}
		if(tgt != null && script != null) {
			extring dlg = extring.stack(128);
			dlg.printf("target:%s\n", tgt.fly().to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
			script.target(tgt);
			while(true) {
				xtring? cmd = script.step();
				if(cmd == null) {
					break;
				}
				dlg.printf("command:%s\n", cmd.fly().to_string());
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
				// execute command
				cmds.act_on(cmd, pad, script);
			}
			if(tgt.fly().equals_static_string("onLoad")) {
				extring varName = extring.set_static_string("__ret_val");
				M100Variable? val = cmds.vars.getProperty(&varName);
				if(val != null)
					registerHookExtensions(tgt, val.strval);
			}
		}
		return 0;
	}
	void registerHookExtensions(extring*fn, extring*funcs) {
		/* sanity check */
		if(funcs.is_empty_magical())
			return;
		BufferedOutputStream outs = new BufferedOutputStream(1024);
		ext.unregisterModule(sourceModule, outs);
		extring token = extring();
		extring inp = extring.stack_copy_deep(funcs);
		while(true) {
			LineExpression.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			//print("registering %s hook\n", token.to_string());
			ext.register(&token, new ShakeExtension(fn, &token, sourceModule), true);
		}
	}
}
/* @} */
