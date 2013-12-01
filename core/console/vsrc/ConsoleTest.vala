using aroop;
using shotodol;

internal class ConsoleTest : UnitTest {
	etxt tname;
	public ConsoleTest() {
		tname = etxt.from_static("Console Test");
	}
	public override aroop_hash getHash() {
		return tname.get_hash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		print("ConsoleTest:~~~~TODO fill me\n");
		return 0;
	}
}

