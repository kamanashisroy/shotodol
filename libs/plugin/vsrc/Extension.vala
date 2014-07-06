using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public abstract class shotodol.Extension : Replicable {
	public abstract Replicable getInstance(etxt*service);
#if false
	public virtual int desc(CommandDescType tp, OutputStream pad) {
		return 0;
	}
#endif
}
/** @}*/
