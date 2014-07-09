using aroop;
using shotodol;

/** \addtogroup test
 *  @{
 */
internal class shotodol.UnitTestCommand : shotodol.M100Command {
	etxt prfx;
	public UnitTestCommand() {
		base();
	}

	~UnitTestCommand() {
		prfx.destroy();
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("test");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) {
		Iterator<container<UnitTest>> pvt = Iterator<container<UnitTest>>.EMPTY();
		UnitTestModule.inst.tests.iterator_hacked(&pvt,  Replica_flags.ALL, 0, 0);
		while(pvt.next()) {
			container<UnitTest> can = pvt.get();
			unowned UnitTest test = can.get();
			test.test();
		}
		return 0;
	}
}
/** @}*/
