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
		addOptionString("-load", M100Command.OptionType.TXT, Options.LOAD, "Load given module");
		addOptionString("-unload", M100Command.OptionType.TXT, Options.UNLOAD, "Unload given module"); 
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "List all modules"); 
	}
	
	public override etxt*get_prefix() {
		prfx = etxt.from_static("module");
		return &prfx;
	}

	int load_module_helper(string module) {
		etxt dlg = etxt.stack(128);
		dlg.printf("Trying to load module %s\n", module);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		ModuleLoader.singleton.load_dynamic_module(module);
		dlg.printf("\t\t\t\t %s module is Loaded\n", module);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		return 0;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?fn = vals[Options.LOAD];
		if(fn != null) {
			load_module_helper(fn.to_string());
		}
		fn = vals[Options.UNLOAD];
		if(fn != null) {
			etxt err = etxt.from_static("TODO:unload module\n");
			pad.write(&err);
		}
		if(vals[Options.LIST] != null) {
			CommandServer.server.cmds.list(pad);
		}
		return 0;
	}
}
/* @} */
