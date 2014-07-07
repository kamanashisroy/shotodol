using aroop;
using shotodol;

/**
 * \ingroup command
 * \defgroup command_programming Programming support for command scripts.
 * [Cohesion : Functional]
 */

/** \addtogroup command_programming
 *  @{
 */
public class ProgrammingInstruction : Replicable {
	LessThanCommand?lecmd;
	GreaterThanCommand?gtcmd;
	EqualsCommand?ecmd;
	IfCommand?ifcmd;
	EchoCommand?ecocmd;
	SetVariableCommand?setcmd;
	unowned M100CommandSet?cmdSet;
	public ProgrammingInstruction() {
		cmdSet = null;
	}

	public void register(M100CommandSet gCmdSet) {
		if(cmdSet != null) {
			unregister();
		}
		cmdSet = gCmdSet;
		lecmd = new LessThanCommand(gCmdSet);
		gtcmd = new GreaterThanCommand(gCmdSet);
		ecmd = new EqualsCommand(gCmdSet);
		ifcmd = new IfCommand(gCmdSet);
		ecocmd = new EchoCommand();
		setcmd = new SetVariableCommand(gCmdSet);
		cmdSet.register(lecmd);
		cmdSet.register(gtcmd);
		cmdSet.register(ecmd);
		cmdSet.register(ifcmd);
		cmdSet.register(ecocmd);
		cmdSet.register(setcmd);
	}

	public void unregister() {
		if(cmdSet == null) {
			return;
		}
		cmdSet.unregister(lecmd);
		cmdSet.unregister(gtcmd);
		cmdSet.unregister(ecmd);
		cmdSet.unregister(ifcmd);
		cmdSet.unregister(ecocmd);
		cmdSet.unregister(setcmd);
	}
}
