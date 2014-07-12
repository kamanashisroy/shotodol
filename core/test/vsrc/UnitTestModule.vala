using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup test Module Testing code(test)
 */

/** \addtogroup test
 *  @{
 */
public class shotodol.UnitTestModule : ModulePlugin {
	class UnitTestModule() {
		name = etxt.from_static("unittest");
	}

	~UnitTestModule() {
	}

	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new UnitTestCommand(), this));
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
