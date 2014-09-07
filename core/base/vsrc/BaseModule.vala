using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public class shotodol.BaseModule : Module {
	MainTurbine?mt;
	public BaseModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
		mt = null;
	}

	public override int init() {
		extring entry = extring.set_static_string("onQuit");
		Plugin.register(&entry, new HookExtension((onQuitHook), this));
		entry.rebuild_and_set_static_string("onReadyAlter");
		Plugin.register(&entry, new HookExtension((onReadyAlterHook), this));
		entry.rebuild_and_set_static_string("run");
		Plugin.register(&entry, new HookExtension((runHook), this));
		entry.rebuild_and_set_static_string("rehash");
		Plugin.register(&entry, new HookExtension((onRehashHook), this));
		return 0;
	}

	public override int deinit() {
		//base.deinit();
		return 0;
	}

	int onReadyAlterHook(extring*msg, extring*output) {
		mt = new MainTurbine();
		mt.rehash();
		return 0;
	}

	int onRehashHook() {
		if(mt != null)mt.rehash();
		return 0;
	}

	int runHook(extring*msg, extring*output) {
		if(mt != null)mt.startup();
		return 0;
	}

	int onQuitHook(extring*msg, extring*output) {
		if(mt != null)mt.quit();
		return 0;
	}
}
