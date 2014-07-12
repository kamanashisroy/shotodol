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
	public virtual Replicable?getInstance(etxt*service) {
		return null;
	}
	public virtual int desc(OutputStream pad) {
		etxt dlg = etxt.stack(128);
		dlg.printf("Extension from module [%s]\n", src.getName().to_string());
		pad.write(&dlg);
		return 0;
	}
	/* Message passing */
	public virtual int act(etxt*msg, etxt*output) /*throws M100CommandError.ActionFailed*/ {
		return 0;
	}
}
/** @}*/
