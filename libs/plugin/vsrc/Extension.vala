using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public class shotodol.Extension : Replicable {
	internal Extension?next;
	internal unowned Module?src;
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
		dlg.concat_char('\t');
		dlg.concat_char('[');
		dlg.concat(&name);
		dlg.concat_char(']');
		dlg.concat_char('\t');
		dlg.concat_char('\t');
		pad.write(&dlg);
		return 0;
	}
	/* Message passing */
	public virtual int act(extring*msg, extring*output) /*throws M100CommandError.ActionFailed*/ {
		return 0;
	}
}
/** @}*/
