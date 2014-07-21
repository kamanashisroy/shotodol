using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup turbine Individual thread(turbine)
 * [Cohesion : Functional]
 */

/** \addtogroup turbine
 *  @{
 */
public errordomain TurbineError {
	PLATFORM_THREAD_FAILED,
}

public class shotodol.Turbine : Propeller {
	shotodol_platform.PlatformThread pt;
	public Turbine() {
		base();
		pt = shotodol_platform.PlatformThread();
	}
	public void startup() throws TurbineError {
		int ecode = pt.start(() => {print("We are going\n");start(null);return 0;});
		if(ecode != 0) {
			throw new TurbineError.PLATFORM_THREAD_FAILED("I cannot say more");
		}
	}
	public int gearup(Spindle sp) {
		sps.add(sp);
		return 0;
	}
	public int geardown(Spindle sp) {
		print("BUG: cannot remove the spindle\n");
		//sps.remove(sp);
		return -1;
	}
}
/** @}*/
