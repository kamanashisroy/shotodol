using aroop;
using shotodol;

/** \addtogroup fileconfig
 *  @{
 */
internal class FileConfigTest : UnitTest {
	etxt tname;
	public FileConfigTest() {
		tname = etxt.from_static("FileConfig Test");
	}
	public override aroop_hash getHash() {
		return tname.getStringHash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		print("FileConfigTest:~~~~TODO fill me\n");
		return 0;
	}
}

/* @} */
