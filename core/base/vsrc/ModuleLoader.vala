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
		loadStatic(new RenuModule());
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
		// We need to be very careful to unload a dynamic module. This is because the references or accesss to the dynamic library after unloading may result in seg fault .
		for(i = count-1; i >= 0; i--) {
			unowned shotodol_platform.dynalib?owner = null; // dynamic library should unload after all the references to the code are unlinked
			{ // This scope makes sure that the module instance is destroyed ..
				Module? m = modules.get(i);
				if(m != null) {
					extring nm = extring();
					m.getNameAs(&nm);
					print("Unregistering %s from registry ..\n", nm.to_string());
					Plugin.unregisterModule(m);
					print("Deinit %s ..\n", nm.to_string());
					nm.destroy();
					// unload dynamic module is prone to crash ..
					if(m.isDynamic) {
						owner = ((DynamicModule)m).owner;
					}
					m.deinit();
					print("Done\n");
				}
				modules.set(i, null);
				modules.gc_unsafe(); // make sure that we do not keep any reference to the module .
				core.gc_unsafe(); // let all the objects destroyed and collected
			} // This scope makes sure that the module instance is destroyed ..
			if(owner != null) {
				// So this is the dynamic library of the last unloaded module ..
				print("Unloading dynamic objects ..\n");
				owner.unload();
				print("Done\n");
			}
			core.gc_unsafe(); // let all the objects destroyed and collected
		}
		count = 0;
		return 0;
	}
}
/* @} */

