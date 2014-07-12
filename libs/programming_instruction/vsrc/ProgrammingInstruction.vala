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
public class ProgrammingInstruction : Module {
	public ProgrammingInstruction() {
		name = etxt.from_static("programming");
	}

	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new LessThanCommand(), this));
		Plugin.register(command, new M100Extension(new GreaterThanCommand(), this));
		Plugin.register(command, new M100Extension(new EqualsCommand(), this));
		Plugin.register(command, new M100Extension(new IfCommand(), this));
		Plugin.register(command, new M100Extension(new EchoCommand(), this));
		Plugin.register(command, new M100Extension(new SetVariableCommand(), this));
		return 0;
	}

	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
}
