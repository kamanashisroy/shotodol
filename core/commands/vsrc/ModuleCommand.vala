using aroop;
using shotodol;

/** \addtogroup command
 *  @{
 */
internal class shotodol.ModuleCommand : M100Command {
	enum Options {
		LOAD = 1,
		UNLOAD,
		LIST,
	}
	public ModuleCommand() {
		var prefix = extring.copy_static_string("module");
		base(&prefix);
		addOptionString("-load", M100Command.OptionType.TXT, Options.LOAD, "Load given module");
		addOptionString("-unload", M100Command.OptionType.TXT, Options.UNLOAD, "Unload given module"); 
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "List all modules"); 
	}

	int load_module_helper(string module) {
		extring dlg = extring.stack(128);
		dlg.printf("Trying to load module %s\n", module);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		ModuleLoader.singleton.load_dynamic_module(module);
		dlg.printf("\t\t\t\t %s module is Loaded\n", module);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		return 0;
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?fn = vals[Options.LOAD];
		if(fn != null) {
			load_module_helper(fn.fly().to_string());
		}
		fn = vals[Options.UNLOAD];
		if(fn != null) {
			ModuleLoader.singleton.unloadModuleByName(fn);
		}
		if(vals[Options.LIST] != null) {
			CommandModule.server.cmds.list(pad);
		}
		return 0;
	}
}
/* @} */
