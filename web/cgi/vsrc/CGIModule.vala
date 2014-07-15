using aroop;
using shotodol;
using shotodol.web;

/**
 * \ingroup web
 * \defgroup cgi CGI library
 * [Cohesion : Functional]
 */

/** \addtogroup cgi
 *  @{
 */
public class shotodol.web.CGIModule : shotodol.DynamicModule {
	public CGIModule() {
	}
	public override int init() {
		txt spindle = new txt.from_static("MainSpindle");
		Plugin.register(spindle, new AnyInterfaceExtension(new CGIReaderSpindle(), this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new CGIModule();
	}
}
/** @}*/
