using aroop;
using shotodol;

/** \addtogroup make
 *  @{
 */

internal class ShakeTest : UnitTest {
	etxt tname;
	public ShakeTest() {
		tname = etxt.from_static("Shake Test");
	}
	public override aroop_hash getHash() {
		return tname.getStringHash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	void loadScript(M100Script script) {
		script.startParsing();
		etxt x = etxt.stack(128);
		x.printf("\n");
		x.printf("shaketest:\n");
		script.parseLine(&x);
		x.printf("\tset -var shaketest -val 1\n");
		script.parseLine(&x);
		x.printf("\tif $(shaketest)\n");
		script.parseLine(&x);
		x.printf("\t\techo Testing\n");
		script.parseLine(&x);
		x.printf("shakenotest:\n");
		script.parseLine(&x);
		x.printf("\tset -var shaketest -val 0\n");
		script.parseLine(&x);
		x.printf("\n");
		script.parseLine(&x);
		script.endParsing();
	}
	void shakeScript(M100Script script) {
		StandardOutputStream so = new StandardOutputStream();
		etxt cmd = etxt.from_static("shake -t shaketest\n");
		CommandModule.server.cmds.act_on(&cmd, so, script);
	}
	public override int test() throws UnitTestError {
		M100Script script = new M100Script();
		loadScript(script);
		shakeScript(script);
		// check value
		bool success = false;
		etxt varname = etxt.from_static("shaketest");
		M100Variable?val = CommandModule.server.cmds.vars.get(&varname);
		etxt dlg = etxt.stack(128);
		dlg.concat(&tname);
		dlg.concat_char(':');
		if(val != null && val.intval == 1) {
			success = true;
			dlg.concat_string("Success");
		} else {
			success = false;
			dlg.concat_string("Fail");
		}
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),1,success?Watchdog.WatchdogSeverity.LOG:Watchdog.WatchdogSeverity.ERROR,0,0,&dlg);
		return 0;
	}
}

/* @} */
