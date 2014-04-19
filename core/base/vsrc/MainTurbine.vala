using aroop;
using shotodol;

/** \addtogroup base
 *  @{
 */
public class shotodol.MainTurbine : shotodol.Propeller {
	private static MainTurbine? mt = null;
	public MainTurbine() {
		base();
		mt = this;
	}
	public int startup() {
		return start(null);
	}
	public static int gearup(Spindle sp) {
		mt.sps.add(sp);
		return 0;
	}
	public static int geardown(Spindle sp) {
		print("BUG: cannot remove the spindle\n");
		//mt.sps.remove(sp);
		return 0;
	}
	public static int quit() { // XXX we should not be call by anyone to quit the application, this is security violation
		mt.cancel();
		return 0;
	}
}

/* @} */
