using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public class shotodol.MainTurbine : shotodol.Fiber16x {
	public MainTurbine() {
		base();
	}
	public int startup() {
		return start(null);
	}
	public int rehash() {
		clearAll();
		if(state == CompositeFiber.CompositeFiberState.CANCELLED || state == CompositeFiber.CompositeFiberState.CANCELLING) {
			return 0;
		}
		extring mains = extring.set_static_string("MainFiber");
		PluginManager.acceptVisitor(&mains, (x) => {
			Fiber?a = (Fiber)x.getInterface(null);
			if(a != null) {
				append(a);
			}
		});
		return 0;
	}
	public int quit() { // XXX we should not be called by anyone to quit the application, this is security violation
		cancel();
		clearAll();
		return 0;
	}
}

/* @} */
