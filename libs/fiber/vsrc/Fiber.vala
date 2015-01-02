using aroop;
using shotodol;

/** \addtogroup fiber
 *  @{
 */
public abstract class shotodol.Fiber : Replicable {
	public bool started;
	public Fiber() {
		started = false;
	}
	public abstract int start(Fiber?plr);
	public abstract int step();
	public abstract int cancel();
}
/** @}*/
