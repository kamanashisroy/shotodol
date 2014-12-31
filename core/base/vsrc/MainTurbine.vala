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
		if(state == PropellerState.CANCELLED || state == PropellerState.CANCELLING) {
			return 0;
		}
#if SHOTODOL_FORK_DEBUG
		int spindleCount = 0;
#endif
		extring mains = extring.set_static_string("MainSpindle");
		Plugin.acceptVisitor(&mains, (x) => {
			Spindle?sp = (Spindle)x.getInterface(null);
			if(sp != null) {
				sps.add(sp);
#if SHOTODOL_FORK_DEBUG
				spindleCount++;
#endif
			}
		});
#if SHOTODOL_FORK_DEBUG
		print("*** %d(%d) spindles registered to main turbine.\n", spindleCount, sps.count_unsafe());
#endif
		return 0;
	}
	public int quit() { // XXX we should not be called by anyone to quit the application, this is security violation
		cancel();
		clearAll();
		return 0;
	}
}

/* @} */
