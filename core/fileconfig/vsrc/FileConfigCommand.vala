using aroop;
using shotodol;

/** \addtogroup fileconfig
 *  @{
 */
internal class shotodol.FileConfigCommand : shotodol.M100Command {
	enum Options {
		INFILE = 1,
	}
	public FileConfigCommand() {
		estr prefix = estr.set_static_string("fileconf");
		base(&prefix);
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Config file");
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<str> vals = ArrayList<str>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		str?infile = vals[Options.INFILE];
		if(infile == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		FileInputStream fis = new FileInputStream.from_file(infile);
		LineInputStream lis = new LineInputStream(fis);
		ConfigEngine?cfg = DefaultConfigEngine.getDefault();
		if(cfg == null) {
			cfg = new DefaultConfigEngine();
			DefaultConfigEngine.setDefault(cfg);
		}
		do {
			estr configLine = estr.stack(128);
			try {
				if(lis.read(&configLine) == 0) {
					break;
				}
				cfg.parseEntry(&configLine);
			} catch(IOStreamError.InputStreamError e) {
#if false
				estr dlg = estr.stack(64);
				dlg.printf("Could not read config file:%s\n", e.message);
				Watchdog.watchit(0, Watchdog.WatchdogSeverity.ERROR, 0, &dlg);
#endif
				break;
			}
		} while(true);
		lis.close();
		fis.close();
		return 0;
	}
}
/* @} */
