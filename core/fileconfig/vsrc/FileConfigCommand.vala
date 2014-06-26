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
		etxt input = etxt.from_static("-i");
		etxt input_help = etxt.from_static("Config file");
		addOption(&input, M100Command.OptionType.TXT, Options.INFILE, &input_help);
	}

	~FileConfigCommand() {
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("fileconf");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		container<txt>? mod;
		if((mod = vals.search(Options.INFILE, match_all)) == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		unowned txt infile = mod.get();
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
