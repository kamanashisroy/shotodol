using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */

internal class ConsoleTest : UnitTest {
	etxt tname;
	public ConsoleTest() {
		tname = etxt.from_static("Console Test");
	}
	public override aroop_hash getHash() {
		return tname.getStringHash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		print("ConsoleTest:~~~~TODO fill me\n");
		return 0;
	}
}

/* @} */
