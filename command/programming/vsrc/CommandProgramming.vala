using aroop;
using shotodol;

/**
 * \ingroup command
 * \defgroup command_programming Programming support for command scripts.
 */

/** \addtogroup command_programming
 *  @{
 */
public class CommandProgramming : shotodol.ModulePlugin {
	LessThanCommand lecmd;
	GreaterThanCommand gtcmd;
	EqualsCommand ecmd;
	IfCommand ifcmd;
	EchoCommand ecocmd;
	SetVariableCommand setcmd;
	unowned M100CommandSet cmdSet;
	CommandProgrammingTest cpt;
	public CommandProgramming(M100CommandSet gCmdSet) {
		cmdSet = gCmdSet;
		lecmd = new LessThanCommand(gCmdSet);
		gtcmd = new GreaterThanCommand(gCmdSet);
		ecmd = new EqualsCommand(gCmdSet);
		ifcmd = new IfCommand(gCmdSet);
		ecocmd = new EchoCommand();
		setcmd = new SetVariableCommand(gCmdSet);
		cpt = new CommandProgrammingTest();
		registerCommands();
	}

	~CommandProgramming() {
		unRegisterCommands();
	}

	public void registerCommands() {
		cmdSet.register(lecmd);
		cmdSet.register(gtcmd);
		cmdSet.register(ecmd);
		cmdSet.register(ifcmd);
		cmdSet.register(ecocmd);
		cmdSet.register(setcmd);
	}

	public void unRegisterCommands() {
		cmdSet.unregister(lecmd);
		cmdSet.unregister(gtcmd);
		cmdSet.unregister(ecmd);
		cmdSet.unregister(ifcmd);
		cmdSet.unregister(ecocmd);
		cmdSet.unregister(setcmd);
	}
	
	public override int init() {
		UnitTestModule.inst.register(cpt);
		return 0;
	}
	public override int deinit() {
		base.deinit();
		UnitTestModule.inst.unregister(cpt);
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CommandProgramming(CommandServer.server.cmds);
	}
}
/* @} */
