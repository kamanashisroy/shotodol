using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup str_arms String manipulation support(str_arms)
 */

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.StrArmsModule: Module {
	public StrArmsModule() {
	}
	public override int init() {
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
