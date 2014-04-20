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
	class IdleSpindle : Spindle {
		bool on;
		public IdleSpindle() {
			on = true;
		}
		~IdleSpindle() {
		}
		public override int start(Spindle?plr) {
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

	etxt prfx;
	IdleSpindle sp;
	enum Options {
		IDLE_ON = 1,
		IDLE_OFF,
	}
	public IdleCommand() {
		base();
		sp = new IdleSpindle();
		MainTurbine.gearup(sp);
		etxt on = etxt.from_static("on");
		etxt on_help = etxt.from_static("Start idle process");
		etxt off = etxt.from_static("off");
		etxt off_help = etxt.from_static("Ends idle process");
		addOption(&on, M100Command.OptionType.TXT, Options.IDLE_ON, &on_help);
		addOption(&off, M100Command.OptionType.TXT, Options.IDLE_OFF, &off_help); 
	}

	~IdleCommand() {
		MainTurbine.geardown(sp);
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("idle");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		bool on = false;
		parseOptions(cmdstr, &vals);
		container<txt>? mod;
		mod = vals.search(Options.IDLE_ON, match_all);
		if(mod != null) {
			on = true;
		}
		mod = vals.search(Options.IDLE_OFF, match_all);
		if(mod != null) {
			on = false;
		}
		sp.reset(on);
		bye(pad, true);
		return 0;
	}
}
/* @} */
