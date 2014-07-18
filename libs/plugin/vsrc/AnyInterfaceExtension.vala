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
}
/** @}*/
