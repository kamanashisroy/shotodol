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
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() { // override the abstract method defined in Module class.
		extring entry = extring.set_static_string("goodluck/before"); // declare embedded Xtring that refer to "goodluck/before".
		PluginManager.register(&entry, new HookExtension(onGoodLuckBefore, this)); // register onGoodLuckBefore at "goodluck/before" plugin space.
		entry.rebuild_and_set_static_string("goodluck/after"); // now entry refers to "goodluck/after".
		PluginManager.register(&entry, new HookExtension(onGoodLuckAfter, this)); // register onGoodLuckAfter at "goodluck/after" plugin space.
		PluginManager.register(&entry, new HookExtension(onGoodLuckAfter2, this)); // second callback
		entry.rebuild_and_set_static_string("command"); // now entry refers to "command".
		PluginManager.register(&entry, new M100Extension(new GoodLuckCommand(), this)); // register GoodLuckCommand instance as command.
		return 0;
	}
	int onGoodLuckBefore(
			extring*msg, // messaged parameter passed by caller
			extring*output // the response 
		) { // This is called after the goodluck command execution
		output.concat_string("Hello ~~~~ \n"); // says "Hello ~~~~ \n" as response
		return 0;
	}
	int onGoodLuckAfter(extring*msg, extring*output) { // This is called after the goodluck command execution
		if(output == null) // sanity check
			return 0;
		
		if(output != null) {
			output.concat(msg); // concat the given message
		}
		output.concat_string(" see you ~~~~ \n"); // says "See you ~~~~ \n" as response
		return 0;
	}
	int onGoodLuckAfter2(extring*msg, extring*output) { // This is called after the goodluck command execution
		output.concat_string(" ~~~ again\n"); // says " ~~~~ again \n" as response
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

