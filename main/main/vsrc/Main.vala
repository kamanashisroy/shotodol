using aroop;
using shotodol;

/**
 * \defgroup main Main Application
 */

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
		loader.loadCore("shake");
		return 0;
	}
	static int onLoad() {
		txt onLoadX = new txt.from_static("onLoad");
		Plugin.swarm(onLoadX, null, null);
		return 0;
	}
	public static int main() {
		// TODO - if(opt & SHELL) then start console
		MainTurbine mt = new MainTurbine();
		
		ModuleLoader loader = new ModuleLoader();
		loadDefaultModules(loader);
		onLoad();
		mt.startup();
		loader.unloadAll();
		ModuleLoader.singleton = null;
		return 0;
	}
}

/** @}*/
