using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100Extension : Extension {
	M100Command?cmd;
	public M100Extension(M100Command gCommand, Module mod) {
		base(mod);
		cmd = gCommand;
	}
	public override Replicable?getInstance(etxt*service) {
		return cmd;
	}
	public override int desc(OutputStream pad) {
		base.desc(pad);
		cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
		return 0;
	}
}
/** @}*/
