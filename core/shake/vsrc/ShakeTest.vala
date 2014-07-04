using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */

internal class ShakeTest : UnitTest {
	etxt tname;
	public ShakeTest() {
		tname = etxt.from_static("Shake Test");
	}
	public override aroop_hash getHash() {
		return tname.getStringHash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		print("ShakeTest:~~~~TODO fill me\n");
		return 0;
	}
}

/* @} */
