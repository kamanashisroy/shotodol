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
	estr name;
	public UnitTest(estr*nm) {
		name = estr.copy_on_demand(nm);
	}
	~UnitTest() {
		name.destroy();
	}
	public void getNameAs(estr*nm) {
		nm.rebuild_and_copy_on_demand(&name);
	}
	public aroop_hash getHash() {
		return name.getStringHash();
	}
	public abstract int test() throws UnitTestError;
	public virtual int assert(bool exp) throws UnitTestError {
		throw new UnitTestError.FAILED("Assertion failed\n");
	}
}
/** @}*/
