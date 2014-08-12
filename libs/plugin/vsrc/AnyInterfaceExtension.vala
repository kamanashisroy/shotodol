using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public class shotodol.AnyInterfaceExtension : Extension {
	Replicable?x;
	public AnyInterfaceExtension(Replicable?e, Module mod) {
		base(mod);
		x = e;
	}
	public override Replicable?getInterface(extring*service) {
		return x;
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		extring dlg = extring.stack(128);
		dlg.concat_string("\tInterface,\n");
		pad.write(&dlg);
		return 0;
	}
}
/** @}*/
