using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public class shotodol.Extension : Replicable {
	internal Extension?next;
	internal Module?src;
	public Extension(Module mod) {
		next = null;
		src = mod;
	}
	public Extension?getNext() {
		return next;
	}
	public virtual Replicable?getInterface(estr*service) {
		return null;
	}
	public virtual int desc(OutputStream pad) {
		estr dlg = estr.stack(128);
		estr name = estr();
		src.getNameAs(&name);
		dlg.printf("Extension from module [%s]\n", name.to_string());
		pad.write(&dlg);
		return 0;
	}
	/* Message passing */
	public virtual int act(estr*msg, estr*output) /*throws M100CommandError.ActionFailed*/ {
		return 0;
	}
}
/** @}*/
