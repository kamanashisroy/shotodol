using aroop;
using shotodol;
using shotodol.supershop;

/**
 * \ingroup apps
 * \defgroup supershop It is an example of supershop analogy to plugin manager.
 */

/** \addtogroup supershop
 *  @{
 */
public class shotodol.supershop.SuperShopModule : DynamicModule {
	public SuperShopModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() { // override the abstract method defined in Module class.
		extring entry = extring.set_static_string("command"); // now entry refers to "command".
		PluginManager.register(&entry, new M100Extension(new BuyCommand(), this)); // register BuyCommand instance as command.
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new SuperShopModule();
	}
}
/* @} */

