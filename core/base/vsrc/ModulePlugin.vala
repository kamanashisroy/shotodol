using aroop;
using shotodol;

public errordomain shotodol.plugin_error {
	COULD_NOT_OPEN,
	COULD_NOT_CREATE_INSTANCE,
	COULD_NOT_INITIATE,
}

public abstract class shotodol.ModulePlugin : Module {
	public override int init() {
		owner = null;
		return 0;
	}
	public override int deinit() {
		owner.unload();
		return 0;
	}
//#if SHOTODOL_LOAD_DYNAMIC_MODULE
	unowned shotodol_platform.plugin owner;
	public static Module load_dynamic_module(string filepath) throws plugin_error {
		// load dynamic modules ..
		unowned shotodol_platform.plugin? plg = shotodol_platform.plugin.load(filepath);
		if(plg == null) {
			throw new plugin_error.COULD_NOT_OPEN("Please check the filepath and name");
		}
		ModulePlugin?m = plg.get_instance() as ModulePlugin;
		if(m == null) {
			plg.unload();
			throw new plugin_error.COULD_NOT_CREATE_INSTANCE("Could not create module");
		}
		if(m.init() != 0) {
			m.deinit();
			plg.unload();
			throw new plugin_error.COULD_NOT_INITIATE("Could not initiate module");
		}
		m.owner = plg;
		return m;
	}
//#endif
}

