using aroop;
using shotodol;

internal class shotodol.ModuleCommand : M100Command {
	etxt prfx;
	enum Options {
		LOAD = 1,
		UNLOAD,
		LIST, // TODO show the list of modules
	}
	public ModuleCommand() {
		base();
		etxt load = etxt.from_static("-load");
		etxt load_help = etxt.from_static("loads a module");
		etxt unload = etxt.from_static("-unload");
		etxt unload_help = etxt.from_static("unloads a module");
		addOption(&load, M100Command.OptionType.TXT, Options.LOAD, &load_help);
		addOption(&unload, M100Command.OptionType.TXT, Options.UNLOAD, &unload_help); 
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("module");
		return &prfx;
	}

	int load_module_helper(string module) {
		print("Trying to load module %s\n", module);
		Module.load_dynamic_module(module);
		print("\t\t\t\t %s module is Loaded\n", module);
		return 0;
	}

	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<Module command>");
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		container<txt>? mod;
		mod = vals.search(Options.LOAD, match_all);
		if(mod != null) {
			load_module_helper(mod.get().to_string());
		}
		mod = vals.search(Options.UNLOAD, match_all);
		if(mod != null) {
			print("TODO:unload module\n");
		}
		return 0;
	}
}
