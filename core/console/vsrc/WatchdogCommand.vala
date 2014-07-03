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
		NAME,
	}
	
	Watchdog ?wd;
	HashTable<txt?> namedCmds;
	public WatchdogCommand() {
		base();
		namedCmds = HashTable<txt?>();
		wd = new Watchdog(null, 100);
		addOptionString("-l", M100Command.OptionType.INT, Options.LEVEL, "Set log level");
		addOptionString("-fn", M100Command.OptionType.TXT, Options.FILENAME, "Match filename");
		addOptionString("-ln", M100Command.OptionType.INT, Options.LINENO, "Match Line number");
		addOptionString("-s", M100Command.OptionType.INT, Options.SEVERITY, "Match severity");
		addOptionString("-n", M100Command.OptionType.TXT, Options.NAME, "Name a watch settings, like \n watchdog -fn main.c -n main \n watchdog -n main");
	}

	~WatchdogCommand() {
		wd.stop();
		wd = null;
		namedCmds.destroy();
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("watchdog");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		etxt*sourcefile = null;
		int lineno = -1;
		int logLevel = 3;
		int severity = -1;
		
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		container<txt>? mod;
		bool newNamedCmd = false;
		if((mod = vals.search(Options.FILENAME, match_all)) != null) {sourcefile = mod.get();newNamedCmd = true;} 
		if((mod = vals.search(Options.LINENO, match_all)) != null) {lineno = mod.get().to_int();newNamedCmd = true;} 
		if((mod = vals.search(Options.LEVEL, match_all)) != null) {logLevel = mod.get().to_int();newNamedCmd = true;} 
		if((mod = vals.search(Options.SEVERITY, match_all)) != null) {severity = mod.get().to_int();newNamedCmd = true;} 
		if((mod = vals.search(Options.NAME, match_all)) != null) {
			txt nm = mod.get(); 
			if(newNamedCmd) {
				txt remember = new txt.memcopy_etxt(cmdstr);
				namedCmds.set(nm, remember);
			} else {
				txt?oldCmd = namedCmds.get(nm);
				if(oldCmd != null) {
					return act_on(oldCmd, pad);
				}
			}
		} 
		wd.dump(pad, sourcefile, lineno, logLevel, severity);
		return 0;
	}
}
/* @} */
