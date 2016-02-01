using aroop;
using shotodol;

/**
 * \ingroup shotodol_library
 * \defgroup linterpreter String manipulation support
 * [Cohesion : Functional]
 */

#if false
/** \addtogroup str_arms
 *  @{
 */
public class shotodol.LinterpreterModule: Module {
	public LinterpreterModule() {
	}
	public override int init() {
		// TODO write test code
		return 0;
	}
	public override int deinit() {
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new StrArmsModule();
	}
}
/** @}*/
#endif
