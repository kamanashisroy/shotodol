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
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		extring spindle = extring.set_static_string("MainSpindle");
		Plugin.register(&spindle, new AnyInterfaceExtension(new CGIReaderSpindle(), this));
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
