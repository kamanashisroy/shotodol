using aroop;
using shotodol;

/** \addtogroup bag
 *  @{
 */
public class shotodol.BagModule : Module {
	public BagModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring entry = extring.set_static_string("unittest");
		PluginManager.register(&entry, new AnyInterfaceExtension(new BagTest(), this));
		entry.rebuild_and_set_static_string("bag/factory");
		PluginManager.register(&entry, new AnyInterfaceExtension(new BagFactoryImpl(), this));
		return 0;
	}

	public override int deinit() {
		//Plugin.unregisterModule(this);
		//base.deinit();
		return 0;
	}
}
