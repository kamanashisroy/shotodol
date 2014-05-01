using aroop;
using shotodol;

/**
 * \ingroup command
 * \defgroup command_programming Programming support for command scripts.
 */

/** \addtogroup command_programming
 *  @{
 */
public class CommandProgrammingTest : UnitTest {
	etxt tname;
	public CommandProgrammingTest() {
		tname = etxt.from_static("CommandProgramming Test");
	}
	public override aroop_hash getHash() {
		return tname.get_hash();
	}
	public override void getName(etxt*name) {
		name.dup_etxt(&tname);
	}
	public override int test() throws UnitTestError {
		M100CommandSet cmds = new M100CommandSet();
		CommandProgramming cp = new CommandProgramming(cmds);
		StandardOutputStream so = new StandardOutputStream();
		etxt dlg = etxt.stack(128);
		dlg.concat_string("CommandProgrammingTest:");
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),1,Watchdog.WatchdogSeverity.LOG,0,0,&dlg);
		etxt cmd = etxt.stack(128);
		cmd.concat_string("set -var x -val 1");
		cmds.act_on(&cmd, so);
		cmd.trim_to_length(0);
		cmd.concat_string("if $(x) set -var x -val 3");
		cmds.act_on(&cmd, so);
		cmd.trim_to_length(0);
		cmd.concat_char('x');
		
		M100Variable val = cmds.vars.get(&cmd);
		bool success = false;
		if(val.intval == 3) {
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
