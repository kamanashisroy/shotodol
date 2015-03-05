using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.ScannerUnitTest : UnitTest {
	public ScannerUnitTest() {
		extring nm = extring.set_string(core.sourceModuleName());
		base(&nm);
	}
	bool test_find_str(extring*src, extring*pattern) {
		if(Scanner.find_str(src, pattern) == -1){
			return false;
		}
		return true;			
	}
	public override int test() throws UnitTestError {
		extring src = extring.copy_static_string("hellothisishassanagainhasanend");
		extring pattern = extring.copy_static_string("hasan");
		if(!test_find_str(&src, &pattern))
			throw new UnitTestError.FAILED("Test failed\n");
		return 0;
	}
}

/* @} */
