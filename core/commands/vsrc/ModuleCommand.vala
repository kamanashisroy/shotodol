using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.ModuleCommand : M100Command {
	etxt prfx;
	enum Options {
		LOAD = 1,
		UNLOAD,
		LIST,
	}
	public ModuleCommand() {
		base();
		etxt load = etxt.from_static("-load");
		etxt load_help = etxt.from_static("loads a module");
		etxt unload = etxt.from_static("-unload");
		etxt unload_help = etxt.from_static("unloads a module");
		etxt list = etxt.from_static("-l");
		etxt list_help = etxt.from_static("List all modules");
		addOption(&load, M100Command.OptionType.TXT, Options.LOAD, &load_help);
		addOption(&unload, M100Command.OptionType.TXT, Options.UNLOAD, &unload_help); 
		addOption(&list, M100Command.OptionType.NONE, Options.LIST, &list_help); 
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("module");
		return &prfx;
	}

	int load_module_helper(string module) {
		print("Trying to load module %s\n", module);
		ModuleLoader.singleton.load_dynamic_module(module);
		print("\t\t\t\t %s module is Loaded\n", module);
		return 0;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			desc(CommandDescType.COMMAND_DESC_FULL, pad);
			bye(pad, false);
			return 0;
		}
		container<txt>? mod;
		mod = vals.search(Options.LOAD, match_all);
		if(mod != null) {
			load_module_helper(mod.get().to_string());
		}
		mod = vals.search(Options.UNLOAD, match_all);
		if(mod != null) {
			etxt err = etxt.from_static("TODO:unload module\n");
			pad.write(&err);
		}
		mod = vals.search(Options.LIST, match_all);
		if(mod != null) {
			CommandServer.server.cmds.list(pad);
		}
		bye(pad, true);
		return 0;
	}
}
/* @} */
