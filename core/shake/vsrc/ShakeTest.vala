using aroop;
using shotodol;

/** \addtogroup shake
 *  @{
 */

internal class ShakeTest : UnitTest {
	public ShakeTest() {
		extring tname = extring.set_static_string("Shake");
		base(&tname);
	}
	void loadScript(M100Script script) {
		script.startParsing();
		extring x = extring.stack(128);
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
		extring cmd = extring.set_static_string("shake -t shaketest\n");
		CommandModule.server.cmds.act_on(&cmd, so, script);
	}
	public override int test() throws UnitTestError {
		M100Script script = new M100Script();
		loadScript(script);
		shakeScript(script);
		// check value
		bool success = false;
		extring varname = extring.set_static_string("shaketest");
		M100Variable?val = CommandModule.server.cmds.vars.getProperty(&varname);
		if(val != null && val.intval == 1)throw new UnitTestError.FAILED("Failed\n");
		return 0;
	}
}

/* @} */
