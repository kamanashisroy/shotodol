using aroop;
using shotodol;

internal abstract class NetEchoSpindle : Spindle {
	protected bool poll;
	protected int interval;
	protected shotodol_platform_net.NetStreamPollPlatformImpl pl;
	public NetEchoSpindle() {
		base();
		interval = 10;
		pl = shotodol_platform_net.NetStreamPollPlatformImpl();
		poll = false;
	}
	~NetEchoSpindle() {
	}
	public override int start(Spindle?plr) {
		print("Echo service is up ..\n");
		return 0;
	}

	public override int step() {
		if(!poll) {
			return 0;
		}
		pl.check_events();
		shotodol_platform.ProcessControl.usleep(interval);
		//shotodol_platform.ProcessControl.mesmerize();
		do {
			shotodol_platform_net.NetStreamPlatformImpl*x = pl.next();
			if(x == null) {
				break;
			}
			if(onEvent(x)!=0) {
				break;
			}
		} while(true);
		if(poll) {
			step_more();
		}
		return 0;
	}
	public override int cancel() {
		return 0;
	}
	internal abstract int onEvent(shotodol_platform_net.NetStreamPlatformImpl*x);
	internal abstract int setup(etxt*addr);
	internal virtual int step_more() {
		return 0;
	}
}


