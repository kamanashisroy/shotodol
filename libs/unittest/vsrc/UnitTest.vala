using aroop;
using shotodol;

public errordomain shotodol.UnitTestError {
	FAILED,
}

public abstract class shotodol.UnitTest : Hashable {
	public abstract void getName(etxt*name);
	public abstract aroop_hash getHash();
	public abstract int test() throws UnitTestError;
	public virtual int assert(bool exp) throws UnitTestError {
		throw new UnitTestError.FAILED("Assertion failed\n");
	}
}
