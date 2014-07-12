using aroop;
using shotodol;

/** \addtogroup Plugin
 *  @{
 */
public class shotodol.AnyExtension : Extension {
	Replicable?x;
	public AnyExtension(Replicable?e, Module mod) {
		base(mod);
		x = e;
	}
	public override Replicable?getInstance(etxt*service) {
		return x;
	}
}
/** @}*/
