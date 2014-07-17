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
		unowned string[] argv = core.argv();
		int argc = core.argc();
		estr memory = estr.stack(128);
		Bundler bndlr = Bundler();
		Carton*ctn = (Carton*)memory.to_string();
		bndlr.buildFromCarton(ctn, memory.size());
		int i = 0;
		for(i=0;i<argc;i++) {
			estr x = estr.set_string(argv[i]);
			bndlr.writeETxt(1,&x);
		}
		bndlr.close();
		estr userargs = estr.set_content((string)ctn.data, bndlr.size, null);
		estr onLoadX = estr.set_static_string("onLoad");
		Plugin.swarm(&onLoadX, &userargs, null);
		onLoadX.rebuild_and_set_static_string("onLoadAlter");
		Plugin.swarm(&onLoadX, &userargs, null);
		return 0;
	}
	public static int main() {
		ModuleLoader loader = new ModuleLoader();
		loadDefaultModules(loader);
		onLoad();
		estr run = estr.set_static_string("run");
		Plugin.swarm(&run, null, null);
		loader.unloadAll();
		ModuleLoader.singleton = null;
		return 0;
	}
}

/** @}*/
