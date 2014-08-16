using aroop;
using shotodol;

/**
 * \ingroup apps
 * \defgroup good_luck It is an example of writing hook. It says good luck on program exit.
 */

/** \addtogroup good_luck
 *  @{
 */
public class shotodol.GoodLuckModule : DynamicModule {
	public GoodLuckModule() {
		extring nm = extring.set_static_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring entry = extring.set_static_string("onQuit");
		Plugin.register(&entry, new HookExtension(onQuitHook, this));
		return 0;
	}
	int onQuitHook(extring*msg, extring*output) {
		output.rebuild_and_set_static_string("Good Luck\n");
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new GoodLuckModule();
	}
}
/* @} */

