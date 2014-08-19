using aroop;
using shotodol;

/**
 * \ingroup apps
 * \defgroup httpcommander 
 */

/** \addtogroup httpcommander
 *  @{
 */
public class shotodol.HTTPModule : shotodol.Module {
	public HTTPModule() {
		extring nm = extring.set_string(core.sourceModuleName());
	}
	public override int init() {
		// TODO listen to 80 port
		// register commands
		return 0;
	}

	public override int deinit() {
		return 0;
	}
}
/* @} */
