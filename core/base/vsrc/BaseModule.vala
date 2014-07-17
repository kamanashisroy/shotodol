using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public class shotodol.BaseModule : Module {
	MainTurbine?mt;
	public BaseModule() {
		estr nm = estr.set_static_string("base");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
		mt = null;
	}

	public override int init() {
		estr entry = estr.set_static_string("onQuit");
		Plugin.register(&entry, new HookExtension((onQuitHook), this));
		entry.rebuild_and_set_static_string("onLoadAlter");
		Plugin.register(&entry, new HookExtension((onLoadAlterHook), this));
		entry.rebuild_and_set_static_string("run");
		Plugin.register(&entry, new HookExtension((runHook), this));
		entry.rebuild_and_set_static_string("rehash");
		Plugin.register(&entry, new HookExtension((onRehashHook), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	int onLoadAlterHook(estr*msg, estr*output) {
		mt = new MainTurbine();
		mt.rehash();
		return 0;
	}

	int onRehashHook() {
		if(mt != null)mt.rehash();
		return 0;
	}

	int runHook(estr*msg, estr*output) {
		if(mt != null)mt.startup();
		return 0;
	}

	int onQuitHook(estr*msg, estr*output) {
		if(mt != null)mt.quit();
		return 0;
	}
}
