using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public errordomain shotodol.plugin_error {
	COULD_NOT_OPEN,
	COULD_NOT_CREATE_INSTANCE,
	COULD_NOT_INITIATE,
}

public class shotodol.ModuleLoader : Replicable {
	ArrayList<Module> modules;
	int count;
	etxt path_to_shotodol;
	public static ModuleLoader singleton;

	public ModuleLoader() {
		path_to_shotodol = etxt(shotodol_platform.plugin.rootDir);
		modules = ArrayList<ModulePlugin>();
		count = 0;
		//load_module_helper("iostream", "libs");
		load("str_arms", "libs");
		loadStatic(new Plugin());
		singleton = this;
	}

	~ModuleLoader() {
		unloadAll();
		modules.destroy();
	}

	public void load_dynamic_module(string filepath) throws plugin_error {
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
		m.initDynamic(plg);
		modules.set(count++, m);
		print("\t\t\t\t %s module is Loaded\n", filepath);
	}

	public int load(string module_name, string dir) {
		print("Trying to load module %s%s/%s\n", path_to_shotodol.to_string(), dir, module_name);
		etxt path = etxt.stack(128);
		path.printf("%s%s/%s/plugin.so", path_to_shotodol.to_string(), dir, module_name);
		load_dynamic_module(path.to_string());
		return 0;
	}

	public int loadStatic(Module m) throws plugin_error {
		if(m.init() != 0) {
			m.deinit();
			throw new plugin_error.COULD_NOT_INITIATE("Could not initiate module");
		}
		modules.set(count++, m);
		etxt nm = etxt.EMPTY();
		m.getNameAs(&nm);
		print("\t\t\t\t %s module(static) is Loaded\n", nm.to_string());
		return 0;
	}

	public int loadCore(string module_name) {
		load(module_name, "core");
		return 0;
	}

	public int unloadAll() {
		int i = 0;
		for(i = count-1; i >= 0; i--) {
			//Module? m = modules.get(i);
			modules.set(i, null);
		}
		count = 0;
		return 0;
	}
}
/* @} */

