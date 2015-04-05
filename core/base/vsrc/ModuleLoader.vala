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
	extring path_to_shotodol;
	public static ModuleLoader singleton;
	ArrayList<Module>moduleStack;
	int stackPointer;

	public ModuleLoader() {
		path_to_shotodol = extring.set_string(shotodol_platform.dynalib.rootDir);
		moduleStack = ArrayList<Module>();
		stackPointer = 0;
		loadStatic(new PluginManager());
		loadStatic(new BaseModule());
		loadStatic(new BagModule());
		singleton = this;
	}

	~ModuleLoader() {
		unloadAll();
		moduleStack.destroy();
	}

	void pushModule(Module x) {
		moduleStack.set(stackPointer++, x);
	}

	void popModuleName(extring*mn) {
		mn.destroy();
		Module? mod = moduleStack.get(stackPointer--);
		if(mod != null) {
			mod.getNameAs(mn);
		}
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
			PluginManager.unregisterModule(m);
			m.deinit();
			plg.unload();
			throw new dynalib_error.COULD_NOT_INITIATE("Could not initiate module");
		}
		m.initDynamic(plg);
		extring mn = extring();
		m.getNameAs(&mn);
		extring dlg = extring.stack(128);
		dlg.printf("\t\t\t\t %s module is Loaded, file:%s\n", mn.to_string(), filepath);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		pushModule(m);
	}

	public int load(string module_name, string dir) {
		extring path = extring.stack(128);
		path.printf("%s%s/%s/dynalib.so", path_to_shotodol.to_string(), dir, module_name);
		if(!shotodol_platform.PlatformFileStream.access(path.to_string(), shotodol_platform.PlatformFileStream.AccessMode.R_OK)) {
			path.printf(".%s/%s/dynalib.so", dir, module_name);
			if(!shotodol_platform.PlatformFileStream.access(path.to_string(), shotodol_platform.PlatformFileStream.AccessMode.R_OK)) {
				extring dlg = extring.stack(128);
				dlg.printf("Failed to load module %s\n", path.to_string());
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,Watchdog.Severity.ERROR,0,0,&dlg);
				return -1;
			}
		}
		extring dlg = extring.stack(128);
		dlg.printf("Trying to load module %s\n", path.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		load_dynamic_module(path.to_string());
		return 0;
	}

	public int loadStatic(Module m) throws dynalib_error {
		// TODO check if the module is already loaded
		if(m.init() != 0) {
			m.deinit();
			throw new dynalib_error.COULD_NOT_INITIATE("Could not initiate module");
		}
		extring mn = extring();
		m.getNameAs(&mn);
		extring dlg = extring.stack(128);
		dlg.printf("\t\t\t\t %s module(static) is Loaded\n", mn.to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		pushModule(m);
		return 0;
	}

	public int loadCore(string module_name) {
		load(module_name, "core");
		return 0;
	}

	public int unloadAll() {
		while(stackPointer >= 0) {
			extring nm = extring();
			popModuleName(&nm);
			if(!nm.is_empty())unloadModuleByName(&nm);
		}
		return 0;
	}

	public int unloadModuleByName(extring*givenModuleName, OutputStream?pad = null) {
		print("Unloading module %s\n", givenModuleName.to_string());
		int pruneFlag = 1<<1;
		aroop.Iterator<AroopPointer<Module>>it = aroop.Iterator<AroopPointer<Module>>();
		moduleStack.iterator_hacked(&it);
		while(it.next()) {
			xtring?moduleName = null;
			unowned shotodol_platform.dynalib?owner = null; // dynamic library should unload after all the references to the code are unlinked
			{ // This scope makes sure that the module instance is destroyed ..
				unowned AroopPointer<Module> map = it.get_unowned();
				Module m = map.getUnowned();
				extring mn = extring();
				m.getNameAs(&mn);
				print("checking %s[%d]-%s[%d]\n", mn.to_string(), mn.length(), givenModuleName.to_string(), givenModuleName.length());
				if(!mn.equals(givenModuleName)) {
					continue;
				}
				print("unloading %s-%s\n", mn.to_string(), givenModuleName.to_string());
				map.mark(pruneFlag);
				moduleName = new xtring.copy_deep(&mn);
				print("Unregistering %s,%d,%s,%d from registry ..\n", mn.to_string(), mn.length() , moduleName.fly().to_string(), moduleName.fly().length());
				PluginManager.unregisterModule(m, pad);
				//print("Deinit %s ..\n", mn.to_string());
				mn.destroy();
				// unload dynamic module is prone to crash ..
				if(m is DynamicModule) {
					owner = ((DynamicModule)m).owner;
				}
				m.deinit();
				it.unlink();
				moduleStack.pruneMarked(pruneFlag);
				//print("Done\n");
				moduleStack.gc_unsafe(); // make sure that we do not keep any reference to the module .
				core.gc_unsafe(); // let all the objects destroyed and collected
				print("Searching %s module\n", moduleName.fly().to_string());
			} // This scope makes sure that the module instance is destroyed ..
			if(moduleName != null && !moduleName.fly().equals_static_string("core/base")) {
				core.assert_no_module_object(moduleName.fly().to_string());
				core.assert_no_module_factory(moduleName.fly().to_string());
			}
			if(owner != null) {
				// So this is the dynamic library of the last unloaded module ..
				print("Unloading dynamic objects ..\n");
				owner.unload();
				print("Done\n");
			}
			core.gc_unsafe(); // let all the objects destroyed and collected
		}
		it.destroy();
		return 0;
	}
}
/* @} */

