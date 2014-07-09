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
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		etxt*sourcefile = null;
		int lineno = -1;
		int logLevel = 3;
		int severity = -1;
		
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt? arg = null;
		bool newNamedCmd = false;
		if((sourcefile = vals[Options.FILENAME]) != null) {newNamedCmd = true;} 
		if((arg = vals[Options.LINENO]) != null) {lineno = arg.to_int();newNamedCmd = true;} 
		if((arg = vals[Options.LEVEL]) != null) {logLevel = arg.to_int();newNamedCmd = true;} 
		if((arg = vals[Options.SEVERITY]) != null) {severity = arg.to_int();newNamedCmd = true;} 
		if((arg = vals[Options.NAME]) != null) {
			txt nm = arg; 
			if(newNamedCmd) {
				txt remember = new txt.memcopy_etxt(cmdstr);
				namedCmds.set(nm, remember);
			} else {
				txt?oldCmd = namedCmds.get(nm);
				if(oldCmd != null) {
					return act_on(oldCmd, pad, cmds);
				}
			}
		} 
		wd.dump(pad, sourcefile, lineno, logLevel, severity);
		return 0;
	}
}
/* @} */
