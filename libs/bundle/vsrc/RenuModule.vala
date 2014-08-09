using aroop;
using shotodol;

/** \addtogroup renu
 *  @{
 */
public class shotodol.RenuModule : Module {
	public RenuModule() {
		extring nm = extring.set_static_string("RenuModule");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring entry = extring.set_static_string("unittest");
		Plugin.register(&entry, new AnyInterfaceExtension(new RenuTest(), this));
		entry.rebuild_and_set_static_string("renu/factory");
		Plugin.register(&entry, new AnyInterfaceExtension(new RenuFactoryImpl(), this));
		return 0;
	}

	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
}
