using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup module Module
 * [Cohesion : Functional]
 */

/** \addtogroup module
 *  @{
 */
public abstract class shotodol.Module : Replicable {
	protected etxt name;
	protected etxt version;
	public virtual etxt*getName() {
		return &name;
	}
#if false
	public virtual etxt*getVersion() {
		return &version;
	}
#endif
	public abstract int init();
	public abstract int deinit();
}
/** @}*/
