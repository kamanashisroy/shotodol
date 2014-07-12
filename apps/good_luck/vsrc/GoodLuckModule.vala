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
		name = etxt.from_static("good_luck");
	}
	public override int init() {
		txt entry = new txt.from_static("onQuit");
		Plugin.register(entry, new HookExtension(onQuitHook, this));
		return 0;
	}
	int onQuitHook(etxt*msg, etxt*output) {
		output.destroy();
		*output = etxt.from_static("Good Luck\n");
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

