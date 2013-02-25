using aroop;
using shotodol;

public errordomain shotodol.plugin_error {
	COULD_NOT_OPEN,
	COULD_NOT_CREATE_INSTANCE,
	COULD_NOT_INITIATE,
}

public abstract class shotodol.Module : Replicable {
	etxt name;
	etxt version;
	public virtual int init() {
		owner = null;
		return 0;
	}
	public virtual int deinit() {
		owner.unload();
		return 0;
	}
//#if SHOTODOL_LOAD_DYNAMIC_MODULE
	shotodol_platform.plugin owner;
	public static Module load_dynamic_module(string filepath) throws plugin_error {
		// load dynamic modules ..
		shotodol_platform.plugin? plg = shotodol_platform.plugin.load(filepath);
		if(plg == null) {
			throw new plugin_error.COULD_NOT_OPEN("Please check the filepath and name");
		}
		print("Found\n");
		Module?m = plg.get_instance();
		if(m == null) {
			plg.unload();
			throw new plugin_error.COULD_NOT_CREATE_INSTANCE("Could not create module");
		}
		print("Got instance\n");
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

