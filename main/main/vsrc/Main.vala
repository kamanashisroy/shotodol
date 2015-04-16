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
		loader.loadCore("shake");
		loader.loadCore("fork");
		loader.loadCore("console");
		loader.loadCore("idle");
		loader.loadCore("profiler");
		loader.loadCore("fileconfig");
		return 0;
	}
	static int onLoad() {
		unowned string[] argv = core.argv();
		int argc = core.argc();
		extring memory = extring.stack(128);
		Bundler bndlr = Bundler();
		bndlr.build(&memory, BundlerAffixes.PREFIX, (uint8)(argc+1));
		int i = 0;
		for(i=0;i<argc;i++) {
			extring x = extring.set_string(argv[i]);
			bndlr.writeEXtring(1,&x);
		}
		bndlr.close();
		memory.truncate(bndlr.size);
		//extring userargs = extring.set_content((string)ctn.data, (int)bndlr.size, null);
		extring hook = extring.set_static_string("onLoad");
		PluginManager.swarm(&hook, &memory, null);
		hook.rebuild_and_set_static_string("onLoadAlter");
		PluginManager.swarm(&hook, &memory, null);
		hook.rebuild_and_set_static_string("onReady");
		PluginManager.swarm(&hook, &memory, null);
		hook.rebuild_and_set_static_string("onReadyAlter");
		PluginManager.swarm(&hook, &memory, null);
		//hook.rebuild_and_set_static_string("rehash");
		//PluginManager.swarm(&hook, &memory, null);
		return 0;
	}
#if false
	static void debugPluginManager(extring*ex) {
		int count = 0;
		Extension?root = PluginManager.get(ex);
		while(root != null) {
			count++;
			Extension?next = root.getNext();
			root = next;
		}
		core.debug_print("There are %d extensions in %S directory\n", count, ex);
	}
#endif
	static void run() {
		onLoad();
		extring run = extring.set_static_string("run");
		PluginManager.swarm(&run, null, null);
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
