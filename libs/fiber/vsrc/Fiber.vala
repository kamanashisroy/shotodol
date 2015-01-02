using aroop;
using shotodol;

/** \addtogroup fiber
 *  @{
 */
public abstract class shotodol.Fiber : Replicable {
	public Fiber() {
	}
	public abstract int start(Fiber?plr);
	public abstract int step();
	public abstract int cancel();
}
/** @}*/
