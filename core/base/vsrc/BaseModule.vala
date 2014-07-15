using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public class shotodol.BaseModule : Module {
	MainTurbine?mt;
	public BaseModule() {
		name = etxt.from_static("base");
		mt = null;
	}

	public override int init() {
		txt entry = new txt.from_static("onQuit");
		Plugin.register(entry, new HookExtension((onQuitHook), this));
		entry = new txt.from_static("onLoadAlter");
		Plugin.register(entry, new HookExtension((onLoadAlterHook), this));
		entry = new txt.from_static("run");
		Plugin.register(entry, new HookExtension((runHook), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}

	int onLoadAlterHook(etxt*msg, etxt*output) {
		mt = new MainTurbine();
		mt.rehash();
		return 0;
	}

	int runHook(etxt*msg, etxt*output) {
		if(mt != null)mt.startup();
		return 0;
	}

	int onQuitHook(etxt*msg, etxt*output) {
		if(mt != null)mt.quit();
		return 0;
	}
}
