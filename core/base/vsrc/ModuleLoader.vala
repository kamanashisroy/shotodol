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
	HashTable<xtring,Module> modules;
	extring path_to_shotodol;
	public static ModuleLoader singleton;
	ArrayList<xtring>moduleStack;
	int stackPointer;

	public ModuleLoader() {
		path_to_shotodol = extring.set_string(shotodol_platform.dynalib.rootDir);
		modules = HashTable<xtring,Module>(xtring.hCb,xtring.eCb);
		moduleStack = ArrayList<xtring>();
		stackPointer = 0;
		loadStatic(new Plugin());
		loadStatic(new BaseModule());
		loadStatic(new RenuModule());
		singleton = this;
	}

	~ModuleLoader() {
		unloadAll();
		modules.destroy();
		moduleStack.destroy();
	}

	void pushModule(Module x) {
		extring mn = extring();
		x.getNameAs(&mn);
		xtring myModuleName = new xtring.copy_on_demand(&mn);
		moduleStack.set(stackPointer++, myModuleName);
	}

	xtring? popModule() {
		return moduleStack.get(stackPointer--);
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
		extring mn = extring();
		m.getNameAs(&mn);
		xtring moduleName = new xtring.copy_deep(&mn);
		modules.set(moduleName, m);
		extring dlg = extring.stack(128);
		dlg.printf("\t\t\t\t %s module is Loaded, file:%s\n", mn.to_string(), filepath);
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		pushModule(m);
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
		extring mn = extring();
		m.getNameAs(&mn);
		xtring moduleName = new xtring.copy_deep(&mn);
		modules.set(moduleName, m);
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
		xtring?moduleName = null;
		while(stackPointer >= 0) {
			if((moduleName = popModule()) != null)
				unloadModuleByName(moduleName);
		}
		return 0;
	}

	public int unloadModuleByName(extring*givenModuleName = null) {
		int pruneFlag = 1<<1;
		aroop.Iterator<AroopPointer<Module>>it = aroop.Iterator<AroopPointer<Module>>.EMPTY();
		modules.iterator_hacked(&it);
		while(it.next()) {
			xtring?moduleName = null;
			unowned shotodol_platform.dynalib?owner = null; // dynamic library should unload after all the references to the code are unlinked
			{ // This scope makes sure that the module instance is destroyed ..
				unowned AroopPointer<Module> map = it.get_unowned();
				Module m = map.getUnowned();
				extring mn = extring();
				m.getNameAs(&mn);
				if(givenModuleName != null && !mn.equals(givenModuleName))
					continue;
				map.mark(pruneFlag);
				moduleName = new xtring.copy_deep(&mn);
				print("Unregistering %s,%d,%s,%d from registry ..\n", mn.to_string(), mn.length() , moduleName.fly().to_string(), moduleName.fly().length());
				Plugin.unregisterModule(m);
				//print("Deinit %s ..\n", mn.to_string());
				mn.destroy();
				// unload dynamic module is prone to crash ..
				if(m.isDynamic) {
					owner = ((DynamicModule)m).owner;
				}
				m.deinit();
				it.unlink();
				modules.pruneMarked(pruneFlag);
				//print("Done\n");
				modules.gc_unsafe(); // make sure that we do not keep any reference to the module .
				core.gc_unsafe(); // let all the objects destroyed and collected
				print("Searching %s module\n", moduleName.fly().to_string());
			} // This scope makes sure that the module instance is destroyed ..
			if(moduleName != null)core.assert_no_module(moduleName.fly().to_string());
			if(owner != null) {
				// So this is the dynamic library of the last unloaded module ..
				//print("Unloading dynamic objects ..\n");
				owner.unload();
				//print("Done\n");
			}
			core.gc_unsafe(); // let all the objects destroyed and collected
		}
		it.destroy();
		return 0;
	}
}
/* @} */

