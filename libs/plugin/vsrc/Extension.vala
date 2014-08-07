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
	internal Extension?getNext() {
		return next;
	}
	public virtual Replicable?getInterface(extring*service) {
		return null;
	}
	public virtual int desc(OutputStream pad) {
		extring dlg = extring.stack(128);
		extring name = extring();
		src.getNameAs(&name);
		dlg.printf("Extension from module [%s]\n", name.to_string());
		pad.write(&dlg);
		return 0;
	}
	/* Message passing */
	public virtual int act(extring*msg, extring*output) /*throws M100CommandError.ActionFailed*/ {
		return 0;
	}
}
/** @}*/
