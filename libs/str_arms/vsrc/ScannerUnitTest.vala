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
	bool test_tokenize_simple() {
		extring buf = extring.stack(128);
		extring sentence = extring.set_static_string("Good luck, have a nice day.");
		extring word = extring();
		int i = 0;
		while(Scanner.next_token(&sentence, &word) == 0) {
			i++;
			buf.concat_string("Token:[");
			buf.concat(&word);
			buf.concat_string("],left:[");
			buf.concat(&sentence);
			buf.concat_string("]");
			buf.zero_terminate();
			print("%s\n", buf.to_string());
			buf.truncate();
			if(sentence.is_empty())
				break;
		}
		return i == 6;			
	}
	public override int test() throws UnitTestError {
		extring src = extring.copy_static_string("hellothisishassanagainhasanend");
		extring pattern = extring.copy_static_string("hasan");
		if(!test_find_str(&src, &pattern))
			throw new UnitTestError.FAILED("Test failed\n");
		if(!test_tokenize_simple())
			throw new UnitTestError.FAILED("Test failed\n");
		return 0;
	}
}

/* @} */
