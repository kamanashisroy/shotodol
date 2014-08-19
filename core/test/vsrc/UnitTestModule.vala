using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup test Module Testing code(test)
 */

/** \addtogroup test
 *  @{
 */
public class shotodol.UnitTestModule : DynamicModule {
	class UnitTestModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	~UnitTestModule() {
	}

	public override int init() {
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new UnitTestCommand(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	
	/*internal int test_comp(container<UnitTest> can) {
		return 0;
	}*/

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new UnitTestModule();
	}
}
/** @}*/
