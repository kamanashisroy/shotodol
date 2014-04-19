using aroop;
using shotodol;

/** \addtogroup main
 *  @{
 */
public class shotodol.MainProgram {
	static int loadDefaultModules(ModuleLoader loader) {
		loader.loadCore("commands");
		loader.loadCore("test");
		loader.loadCore("console");
		loader.loadCore("idle");
		loader.loadCore("profiler");
		loader.loadCore("fileconfig");
		loader.loadCore("make");
		return 0;
	}
	public static int main() {
		// TODO load lua
		// TODO - if(opt & SHELL) then start console
		MainTurbine mt = new MainTurbine();
		
		ModuleLoader loader = new ModuleLoader();
		loadDefaultModules(loader);
		mt.startup();
		loader.unloadAll();
		ModuleLoader.singleton = null;
		return 0;
	}
}

/** @}*/
