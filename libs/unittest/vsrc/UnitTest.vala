using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup unittest Unit Testing Support(unittest)
 * [Cohesion : Functional]
 */

/** \addtogroup unittest
 *  @{
 */
public errordomain shotodol.UnitTestError {
	FAILED,
}

public abstract class shotodol.UnitTest : Hashable {
	extring name;
	public UnitTest(extring*nm) {
		name = extring.copy_on_demand(nm);
	}
	~UnitTest() {
		name.destroy();
	}
	public void getNameAs(extring*nm) {
		nm.rebuild_and_copy_on_demand(&name);
	}
	public aroop_hash getHash() {
		return name.getStringHash();
	}
	public abstract int test() throws UnitTestError;
	public virtual int testassert(bool exp) throws UnitTestError { // XXX calling the method is not working !!!
		if(!exp)throw new UnitTestError.FAILED("Assertion failed\n");
		return 0;
	}
}
/** @}*/
