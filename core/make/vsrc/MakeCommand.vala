using aroop;
using shotodol;

internal class MakeCommand : M100Command {
	etxt prfx;
	enum Options {
		TARGET = 1,
		FILE,
	}
	public MakeCommand() {
		base();
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
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Make command>");
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		container<txt>? mod;
		mod = vals.search(Options.FILE, match_all);
		if(mod != null) {
			// TODO parse the file
			// script = new M100Script();
		}
		mod = vals.search(Options.TARGET, match_all);
		if(mod != null && script != null) {
			script.target(mod);
			while(true) {
				txt? cmd = script.step();
				if(cmd == null) {
					break;
				}
				// execute command
				CommandServer.server.act_on(cmd, io);
			}
		}
		return 0;
	}
}
