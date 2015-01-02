using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup idle Let cpu take rest(idle)
 */

/** \addtogroup idle
 *  @{
 */

internal class IdleCommand : M100Command {
	internal class IdleFiber : Fiber {
		bool on;
		public IdleFiber() {
			on = true;
		}
		~IdleFiber() {
		}
		public override int start(Fiber?plr) {
			print("Started idle stepping ..\n");
			return 0;
		}

		public override int step() {
			if(!on) {
				return 0;
			}
			shotodol_platform.ProcessControl.mesmerize();
			return 0;
		}
		public override int cancel() {
			return 0;
		}
		internal void reset(bool state) {
			// XXX we shoud have used cancel here
			on = state;
		}
	}

	IdleFiber sp;
	enum Options {
		IDLE_ON = 1,
		IDLE_OFF,
	}
	public IdleCommand(IdleFiber gSp) {
		extring prefix = extring.set_static_string("idle");
		base(&prefix);
		sp = gSp;
		addOptionString("-on", M100Command.OptionType.NONE, Options.IDLE_ON, "Start idle process");
		addOptionString("-off", M100Command.OptionType.NONE, Options.IDLE_OFF, "Ends idle process"); 
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		bool on = false;
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		if(vals[Options.IDLE_ON] != null) {
			on = true;
		}
		if(vals[Options.IDLE_OFF] != null) {
			on = false;
		}
		sp.reset(on);
		return 0;
	}
}
/* @} */
