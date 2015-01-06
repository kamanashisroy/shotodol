using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup spinningwheel Individual thread(SpinningWheel)
 * [Cohesion : Functional]
 */

/** \addtogroup spinningwheel
 *  @{
 */
public errordomain SpinningWheelError {
	PLATFORM_THREAD_FAILED,
}

public class shotodol.SpinningWheel : CompositeFiber {
	shotodol_platform.PlatformThread pt;
	public SpinningWheel() {
		base();
		pt = shotodol_platform.PlatformThread();
	}
	public void startup() throws SpinningWheelError {
		int ecode = pt.start(() => {print("We are going\n");start(null);return 0;});
		if(ecode != 0) {
			throw new SpinningWheelError.PLATFORM_THREAD_FAILED("I cannot say more");
		}
	}
	public int gearup(Fiber sp) {
		sps.add(sp);
		return 0;
	}
	public int geardown(Fiber sp) {
		print("BUG: cannot remove the spindle\n");
		//sps.remove(sp);
		return -1;
	}
}
/** @}*/
