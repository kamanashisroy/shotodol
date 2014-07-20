using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public class shotodol.MainTurbine : shotodol.Propeller {
	public MainTurbine() {
		base();
	}
	public int startup() {
		return start(null);
	}
	public int rehash() {
		clearAll();
		extring mains = extring.set_static_string("MainSpindle");
		Extension?root = Plugin.get(&mains);
		while(root != null) {
			Spindle?sp = (Spindle)root.getInterface(null);
			if(sp != null)
				sps.add(sp);
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
	public int quit() { // XXX we should not be call by anyone to quit the application, this is security violation
		cancel();
		return 0;
	}
}

/* @} */
