using aroop;
using shotodol;

/**
 * \ingroup command
 * \defgroup programming_instruction Programming support for command scripts.
 */

/** \addtogroup programming_instruction
 *  @{
 */
public class ProgrammingInstructionTest : UnitTest {
	public ProgrammingInstructionTest() {
		extring tname = extring.copy_static_string("ProgrammingInstruction Test");
		base(&tname);
	}

	public override int test() throws UnitTestError {
#if false
		M100CommandSet cmds = new M100CommandSet();
		ProgrammingInstruction cp = new ProgrammingInstruction();
		cp.register(cmds);
		StandardOutputStream so = new StandardOutputStream();
		extring dlg = extring.stack(128);
		dlg.concat_string("ProgrammingInstructionTest:");
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),1,Watchdog.WatchdogSeverity.LOG,0,0,&dlg);
		extring cmd = extring.stack(128);
		cmd.concat_string("set -var x -val 1");
		cmds.act_on(&cmd, so, null);
		cmd.trim_to_length(0);
		cmd.concat_string("if $(x) set -var x -val 3");
		cmds.act_on(&cmd, so, null);
		cmd.trim_to_length(0);
		cmd.concat_char('x');
		
		M100Variable?val = cmds.vars.get(&cmd);
		bool success = false;
		dlg.trim_to_length(0);
		dlg.concat_string("ProgrammingInstructionTest:");
		if(val != null && val.intval == 3) {
			success = true;
			dlg.concat_string("Success");
		} else {
			success = false;
			dlg.concat_string("Fail");
		}
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),1,success?Watchdog.WatchdogSeverity.LOG:Watchdog.WatchdogSeverity.ERROR,0,0,&dlg);
		cp.unregister();
#endif
		return 0;
	}
}
/* @} */
