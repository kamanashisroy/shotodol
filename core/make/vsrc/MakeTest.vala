using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */

internal class MakeTest : UnitTest {
	etxt tname;
	public MakeTest() {
		tname = etxt.from_static("Make Test");
	}
	public override aroop_hash getHash() {
		return tname.get_hash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		print("MakeTest:~~~~TODO fill me\n");
		return 0;
	}
}

/* @} */
