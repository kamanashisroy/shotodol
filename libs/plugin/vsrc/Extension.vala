using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public class shotodol.Extension : Replicable {
	internal Extension?next;
	internal Module?src;
	Replicable?x;
	public Extension(Module mod) {
		next = null;
		x = null;
		src = mod;
	}
	public Extension.for_service(Replicable a, Module mod) {
		next = null;
		x = a;
		src = mod;
	}
	public Extension?getNext() {
		return next;
	}
	public virtual Replicable getInstance(etxt*service) {
		return x;
	}
	public virtual int desc(M100Command.CommandDescType tp, OutputStream pad) {
		return 0;
	}
	/* Message passing */
	public virtual int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		return 0;
	}
}
/** @}*/
