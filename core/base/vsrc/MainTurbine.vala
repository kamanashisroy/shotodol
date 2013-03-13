using aroop;
using shotodol;

public class MainTurbine : shotodol.Propeller {
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
}

