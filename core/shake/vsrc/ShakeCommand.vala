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
	etxt prfx;
	enum Options {
		TARGET = 1,
		FILE,
	}
	unowned M100CommandSet cmdSet;
	public ShakeCommand(M100CommandSet gCmdSet) {
		base();
		cmdSet = gCmdSet;
		addOptionString("-t", M100Command.OptionType.TXT, Options.TARGET, "target name");
		addOptionString("-f", M100Command.OptionType.TXT, Options.FILE, "shake file name/path"); 
		script = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("shake");
		return &prfx;
	}
	M100Script? script;
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?fn = vals[Options.FILE];
		txt?tgt = vals[Options.TARGET];
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
						etxt buf = etxt.stack(1024);
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
			etxt dlg = etxt.stack(128);
			dlg.printf("target:%s\n", tgt.to_string());
			Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
			script.target(tgt);
			while(true) {
				txt? cmd = script.step();
				if(cmd == null) {
					break;
				}
				dlg.printf("command:%s\n", cmd.to_string());
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
				// execute command
				cmdSet.act_on(cmd, pad, script);
			}
		}
		return 0;
	}
}
/* @} */
