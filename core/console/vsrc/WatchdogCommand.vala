using aroop;
using shotodol;

internal class shotodol.WatchdogCommand : shotodol.M100Command {
	etxt prfx;
	Watchdog ?wd;
	public WatchdogCommand() {
		base();
		wd = new Watchdog(null, 100);
	}

	~WatchdogCommand() {
		wd.stop();
		wd = null;
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("watchdog");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		wd.dump(pad);
		bye(pad, true);
		return 0;
	}
}
