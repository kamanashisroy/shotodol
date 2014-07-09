using aroop;
using shotodol;

/**
 * \ingroup core
 * \defgroup programming It loads programming commands (say condition and boolean operations etc .)
 */

/** \addtogroup programming
 *  @{
 */
public class shotodol.Programming: Module {
	ProgrammingInstructionTest?cpt;
	ProgrammingInstruction?pgm;
	public Programming() {
		name = etxt.from_static("programming");
	}
	
	public override int init() {
		cpt = new ProgrammingInstructionTest();
		pgm = new ProgrammingInstruction();
		pgm.register(CommandServer.server.cmds);
		UnitTestModule.inst.register(cpt);
		return 0;
	}
	public override int deinit() {
		if(cpt != null)UnitTestModule.inst.unregister(cpt);
		if(pgm != null)pgm.unregister();
		base.deinit();
		return 0;
	}
}
/* @} */
