using aroop;
using shotodol;
public abstract class shotodol.ModulePlugin : Module {
	public override int init() {
		owner = null;
		return 0;
	}
	public override int deinit() {
		owner.unload();
		return 0;
	}
	unowned shotodol_platform.plugin owner;
	public int initDynamic(shotodol_platform.plugin plg) {
		owner = plg;
		return 0;
	}
}

