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
		extring nm = extring.set_static_string("programming");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new LessThanCommand(), this));
		Plugin.register(&command, new M100Extension(new GreaterThanCommand(), this));
		Plugin.register(&command, new M100Extension(new EqualsCommand(), this));
		Plugin.register(&command, new M100Extension(new IfCommand(), this));
		Plugin.register(&command, new M100Extension(new EchoCommand(), this));
		Plugin.register(&command, new M100Extension(new SetVariableCommand(), this));
		return 0;
	}

	public override int deinit() {
		Plugin.unregisterModule(this);
		base.deinit();
		return 0;
	}
}
