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
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		container<txt>? mod;
		mod = vals.search(Options.FILE, match_all);
		if(mod != null) {
			try {
				FileInputStream f = new FileInputStream.from_file(mod.get());
				script = new M100Script();
				etxt buf = etxt.stack(128);
				while(true) {
					try {
						f.read(&buf);
					} catch(IOStreamError.InputStreamError e) {
						break;
					}
					//print(buf.to_string());
					int i = 0;
					int ln_start = 0;
					for(i=0;i<buf.length();i++) {
						if(buf.char_at(i) == '\n') {
							etxt ln = etxt.dup_etxt(&buf);
							if(ln_start != 0) {
								ln.shift(ln_start);
							}
							ln.trim_to_length(i);
							script.parseLine(&ln);
							ln.destroy();
							ln_start = i+1;
						}
					}
				}
				f.close();
			} catch (IOStreamError.FileInputStreamError e) {
			}
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
				CommandServer.server.act_on(cmd, pad);
			}
		}
		return 0;
	}
}
