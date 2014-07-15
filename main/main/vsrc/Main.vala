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
		etxt memory = etxt.stack(128);
		Bundler bndlr = Bundler();
		Carton*ctn = (Carton*)memory.to_string();
		bndlr.buildFromCarton(ctn, memory.size());
		int i = 0;
		for(i=0;i<argc;i++) {
			// TODO optimize
			txt x = new txt.memcopy_zero_terminated_string(argv[i]);
			bndlr.writeETxt(1,x);
		}
		bndlr.close();
		etxt userargs = etxt.given_length((string)ctn.data, bndlr.size, null);
		txt onLoadX = new txt.from_static("onLoad");
		Plugin.swarm(onLoadX, &userargs, null);
		onLoadX = new txt.from_static("onLoadAlter");
		Plugin.swarm(onLoadX, &userargs, null);
		return 0;
	}
	public static int main() {
		ModuleLoader loader = new ModuleLoader();
		loadDefaultModules(loader);
		onLoad();
		Plugin.swarm(new txt.from_static("run"), null, null);
		loader.unloadAll();
		ModuleLoader.singleton = null;
		return 0;
	}
}

/** @}*/
