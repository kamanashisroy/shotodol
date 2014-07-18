using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public errordomain shotodol.dynalib_error {
	COULD_NOT_OPEN,
	COULD_NOT_CREATE_INSTANCE,
	COULD_NOT_INITIATE,
}

public class shotodol.ModuleLoader : Replicable {
	ArrayList<Module> modules;
	int count;
	extring path_to_shotodol;
	public static ModuleLoader singleton;

	public ModuleLoader() {
		path_to_shotodol = extring.set_string(shotodol_platform.dynalib.rootDir);
		modules = ArrayList<Module>();
		count = 0;
		loadStatic(new Plugin());
		loadStatic(new BaseModule());
		singleton = this;
	}

	~ModuleLoader() {
		unloadAll();
		modules.destroy();
	}

	public void load_dynamic_module(string filepath) throws dynalib_error {
		// load dynamic modules ..
		unowned shotodol_platform.dynalib? plg = shotodol_platform.dynalib.load(filepath);
		if(plg == null) {
			throw new dynalib_error.COULD_NOT_OPEN("Please check the filepath and name");
		}
		DynamicModule?m = plg.get_instance() as DynamicModule;
		if(m == null) {
			plg.unload();
			throw new dynalib_error.COULD_NOT_CREATE_INSTANCE("Could not create module");
		}
		if(m.init() != 0) {
			Plugin.unregisterModule(m);
			m.deinit();
			plg.unload();
			throw new dynalib_error.COULD_NOT_INITIATE("Could not initiate module");
		}
		m.initDynamic(plg);
		modules.set(count++, m);
		//print("\t\t\t\t %s module is Loaded\n", filepath);
		extring dlg = extring.stack(128);
		dlg.printf("\t\t\t\t %s module is Loaded\n", filepath);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
	}

	public int load(string module_name, string dir) {
		extring dlg = extring.stack(128);
		dlg.printf("Trying to load module %s%s/%s\n", path_to_shotodol.to_string(), dir, module_name);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		extring path = extring.stack(128);
		path.printf("%s%s/%s/dynalib.so", path_to_shotodol.to_string(), dir, module_name);
		load_dynamic_module(path.to_string());
		return 0;
	}

	public int loadStatic(Module m) throws dynalib_error {
		// TODO check if the module is already loaded
		if(m.init() != 0) {
			m.deinit();
			throw new dynalib_error.COULD_NOT_INITIATE("Could not initiate module");
		}
		modules.set(count++, m);
		extring dlg = extring.stack(128);
		extring nm = extring();
		m.getNameAs(&nm);
		dlg.printf("\t\t\t\t %s module(static) is Loaded\n", nm.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		return 0;
	}

	public int loadCore(string module_name) {
		load(module_name, "core");
		return 0;
	}

	public int unloadAll() {
		int i = 0;
		for(i = count-1; i >= 0; i--) {
			Module? m = modules.get(i);
			if(m != null) {
				extring nm = extring();
				m.getNameAs(&nm);
				print("Unloading %s\n", nm.to_string());
				Plugin.unregisterModule(m);
				m.deinit();
			}
			modules.set(i, null);
		}
		count = 0;
		return 0;
	}
}
/* @} */

