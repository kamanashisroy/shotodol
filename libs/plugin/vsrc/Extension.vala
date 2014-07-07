using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public abstract class shotodol.Extension : Replicable {
	public abstract Replicable getInstance(etxt*service);
	public virtual int desc(M100Command.CommandDescType tp, OutputStream pad) {
		return 0;
	}
	/* Message passing */
	public virtual int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		return 0;
	}
}
/** @}*/
