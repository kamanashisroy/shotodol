using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup shake A shake script parser(shake)
 */

/** \addtogroup shake
 *  @{
 */
internal class ShakeCommand : M100Command {
	enum Options {
		TARGET = 1,
		FILE,
	}
	public ShakeCommand() {
		extring prefix = extring.set_static_string("shake");
		base(&prefix);
		addOptionString("-t", M100Command.OptionType.TXT, Options.TARGET, "target name");
		addOptionString("-f", M100Command.OptionType.TXT, Options.FILE, "shake file name/path"); 
		script = null;
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
			dlg.printf("target:%s\n", tgt.ecast().to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
			script.target(tgt);
			while(true) {
				xtring? cmd = script.step();
				if(cmd == null) {
					break;
				}
				dlg.printf("command:%s\n", cmd.ecast().to_string());
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
				// execute command
				cmds.act_on(cmd, pad, script);
			}
		}
		return 0;
	}
}
/* @} */
