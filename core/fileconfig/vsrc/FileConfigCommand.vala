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
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		do {
			container<txt>? mod;
			if((mod = vals.search(Options.INFILE, match_all)) == null) {
				break;
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
			bye(pad, true);
			return 0;
		} while(false);
		bye(pad, false);
		return 0;
	}
}
/* @} */
