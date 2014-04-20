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
	public static UnitTestModule? inst;
	internal SearchableSet<UnitTest> tests;
	UnitTestCommand? cmd = null;
	class UnitTestModule() {
	}

	~UnitTestModule() {
	}

	public override int init() {
		tests = SearchableSet<UnitTest>();
		inst = this;
		cmd = new UnitTestCommand();
		CommandServer.server.cmds.register(cmd);
		return 0;
	}
	public override int deinit() {
		tests.destroy();
		inst = null;
		CommandServer.server.cmds.unregister(cmd);
		cmd = null;
		base.deinit();
		return 0;
	}
	
	/*internal int test_comp(container<UnitTest> can) {
		return 0;
	}*/

	public int register(UnitTest t) {
		container<UnitTest>? can = tests.search(t.getHash(), null);
		if(can != null) {
			return -1;
		}
		tests.add_container(t, t.getHash());
		return 0;
	}
	public int unregister(UnitTest t) {
		tests.prune(t.getHash(), t);
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new UnitTestModule();
	}
}
/** @}*/
