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
		extring memory = extring.stack(128);
		Bundler bndlr = Bundler();
		Carton*ctn = (Carton*)memory.to_string();
		bndlr.buildFromCarton(ctn, memory.size(), BundlerAffixes.PREFIX, argc+1);
		int i = 0;
		for(i=0;i<argc;i++) {
			extring x = extring.set_string(argv[i]);
			bndlr.writeETxt(1,&x);
		}
		bndlr.close();
		extring userargs = extring.set_content((string)ctn.data, (int)bndlr.size, null);
		extring hook = extring.set_static_string("onLoad");
		Plugin.swarm(&hook, &userargs, null);
		hook.rebuild_and_set_static_string("onLoadAlter");
		Plugin.swarm(&hook, &userargs, null);
		return 0;
	}
#if false
	static void debugPlugin(extring*ex) {
		int count = 0;
		Extension?root = Plugin.get(ex);
		while(root != null) {
			count++;
			Extension?next = root.getNext();
			root = next;
		}
		print("There are %d extensions in %s directory\n", count, ex.to_string());
	}
#endif
	static void run() {
		onLoad();
		extring run = extring.set_static_string("run");
		Plugin.swarm(&run, null, null);
	}
	public static int main() {
		ModuleLoader loader = new ModuleLoader();
		loadDefaultModules(loader);
		run();
		loader.unloadAll();
		loader.singleton = null;
		return 0;
	}
}

/** @}*/
