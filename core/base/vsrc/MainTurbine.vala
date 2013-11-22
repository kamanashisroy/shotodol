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
	/*
	public static int geardown(Spindle sp) {
		mt.sps.remove(sp);
		return 0;
	}
	*/
	public static int quit() { // XXX we should not all all to quit the application, this is sequrity violation
		mt.cancel();
		return 0;
	}
}

