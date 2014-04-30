using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal class shotodol.WatchdogCommand : shotodol.M100Command {
	etxt prfx;
	enum Options {
		LEVEL = 1,
		FILENAME,
		LINENO,
		SEVERITY,
	}
	
	Watchdog ?wd;
	public WatchdogCommand() {
		base();
		wd = new Watchdog(null, 100);
		etxt level = etxt.from_static("-l");
		etxt level_help = etxt.from_static("Set log level");
		etxt filename = etxt.from_static("-fn");
		etxt filename_help = etxt.from_static("Match filename");
		etxt lineno = etxt.from_static("-ln");
		etxt lineno_help = etxt.from_static("Match line number");
		etxt severity = etxt.from_static("-s");
		etxt severity_help = etxt.from_static("Message severity");
		addOption(&level, M100Command.OptionType.INT, Options.LEVEL, &level_help);
		addOption(&filename, M100Command.OptionType.TXT, Options.FILENAME, &filename_help); 
		addOption(&lineno, M100Command.OptionType.INT, Options.LINENO, &lineno_help); 
		addOption(&severity, M100Command.OptionType.INT, Options.SEVERITY, &severity_help); 

	}

	~WatchdogCommand() {
		wd.stop();
		wd = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("watchdog");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		etxt*sourcefile = null;
		int lineno = -1;
		int logLevel = 3;
		int severity = -1;
		
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			bye(pad, false);
			return 0;
		}
		container<txt>? mod;
		if((mod = vals.search(Options.FILENAME, match_all)) != null) {sourcefile = mod.get();} 
		if((mod = vals.search(Options.LINENO, match_all)) != null) {lineno = mod.get().to_int();} 
		if((mod = vals.search(Options.LEVEL, match_all)) != null) {logLevel = mod.get().to_int();} 
		if((mod = vals.search(Options.SEVERITY, match_all)) != null) {severity = mod.get().to_int();} 
		wd.dump(pad, sourcefile, lineno, logLevel, severity);
		bye(pad, true);
		return 0;
	}
}
/* @} */
