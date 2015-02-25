using aroop;
using shotodol;

/** \addtogroup instant
 *  @{
 */

internal class shotodol.InstantCommand : M100Command {
	M100Script? script;
	internal M100CommandSet?cmds;
	//shotodol.M100Variable vars;
	enum Options {
		LIST = 1,
		GET,
		SET,
	}
	public InstantCommand() {
		extring prefix = extring.set_static_string("instant");
		base(&prefix);
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "Display available instant modules");
		addOptionString("-get", M100Command.OptionType.TXT, Options.GET, "Get binary packages");
		addOptionString("-set", M100Command.OptionType.TXT, Options.SET, "Upload binary packages");
		script = null;
		cmds = new M100CommandSet();
               	//vars = new shotodol.M100Variable();
              	//cmds.vars.set(callInstance, callInstanceVar);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		if(script == null) {
			//extring instpkg = extring.set_static_string(".instant/list.ske");
			extring instpkg = extring.set_static_string("autoload/instant.ske");
			load(&instpkg);
		}
		if(script == null) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("no package found\n");
		}
		if(vals[Options.LIST] != null) {
			// printList(pad);
			extring packages = extring.set_static_string("packages");
			go(&packages, pad);
		}
		if(vals[Options.GET] != null) {
			extring getSuffix = extring.set_static_string("_get");
			go(vals[Options.GET], pad, &getSuffix);
		}
		if(vals[Options.SET] != null) {
			extring setSuffix = extring.set_static_string("_set");
			go(vals[Options.SET], pad, &setSuffix);
		}
		return 0;
	}

#if false
	void printList(OutputStream pad) {
		extring delim = extring.set_static_string(" ");
		script.listBlocks(pad, &delim);
		extring nl = extring.set_static_string("\n");
		pad.write(&nl);
	}
#endif

	void go(extring*pkg, OutputStream pad, extring*suffix = null) {
		if(pkg == null || script == null) {
			return;
		}
		extring dlg = extring.stack(128);
		dlg.printf("package:%s\n", pkg.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		extring x = extring.stack(128); 
		x.concat(pkg);
		if(suffix != null)x.concat(suffix);
		script.target(&x);
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
	}
	void load(extring*fn) {
		try {
			shotodol.FileInputStream f = new shotodol.FileInputStream.from_file(fn);
			shotodol.LineInputStream lis = new shotodol.LineInputStream(f);
			script = new shotodol.M100Script();
			script.startParsing();
			extring buf = extring.stack(1024);
			while(true) {
				try {
					buf.truncate();
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
}
/* @} */
