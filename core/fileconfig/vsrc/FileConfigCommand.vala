using aroop;
using shotodol;

/** \addtogroup fileconfig
 *  @{
 */
internal class shotodol.FileConfigCommand : shotodol.M100Command {
	etxt prfx;
	enum Options {
		INFILE = 1,
	}
	public FileConfigCommand() {
		base();
		addOptionString("-i", M100Command.OptionType.TXT, Options.INFILE, "Config file");
	}

	~FileConfigCommand() {
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("fileconf");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?infile = vals[Options.INFILE];
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
			etxt configLine = etxt.stack(128);
			try {
				if(lis.read(&configLine) == 0) {
					break;
				}
				cfg.parseEntry(&configLine);
			} catch(IOStreamError.InputStreamError e) {
#if false
				etxt dlg = etxt.stack(64);
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
