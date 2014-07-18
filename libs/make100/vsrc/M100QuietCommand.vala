using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */

public abstract class shotodol.M100QuietCommand : M100Command {
	public M100QuietCommand(extring*prefix) {
		base(prefix);
	}

	public override void greet(OutputStream pad) {
	}

	public override void bye(OutputStream pad, bool success) {
	}
}
	
