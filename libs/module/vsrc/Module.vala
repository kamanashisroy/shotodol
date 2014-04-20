using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup module Module
 */

/** \addtogroup module
 *  @{
 */
public abstract class shotodol.Module : Replicable {
	protected etxt name;
	protected etxt version;
#if false
	public virtual etxt*getName() {
		return &name;
	}
	public virtual etxt*getVersion() {
		return &version;
	}
#endif
	public abstract int init();
	public abstract int deinit();
}
/** @}*/
