using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup make A make script parser(make)
 */

/** \addtogroup make
 *  @{
 */
internal class MakeCommand : M100Command {
	etxt prfx;
	enum Options {
		TARGET = 1,
		FILE,
	}
	unowned M100CommandSet cmdSet;
	public MakeCommand(M100CommandSet gCmdSet) {
		base();
		cmdSet = gCmdSet;
		etxt target = etxt.from_static("-t");
		etxt target_help = etxt.from_static("target name");
		etxt file = etxt.from_static("-f");
		etxt file_help = etxt.from_static("make file name/path");
		addOption(&target, M100Command.OptionType.TXT, Options.TARGET, &target_help);
		addOption(&file, M100Command.OptionType.TXT, Options.FILE, &file_help); 
		script = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("make");
		return &prfx;
	}
	M100Script? script;
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		container<txt>? mod;
		mod = vals.search(Options.FILE, match_all);
		if(mod != null) {
			try {
				FileInputStream f = new FileInputStream.from_file(mod.get());
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
		mod = vals.search(Options.TARGET, match_all);
		if(mod != null && script != null) {
			unowned txt tgt = mod.get();
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
