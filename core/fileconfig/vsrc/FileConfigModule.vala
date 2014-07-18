using aroop;
using shotodol;
using shotodol_platform;

/**
 * \ingroup core
 * \defgroup fileconfig File based config parser/loader(fileconfig)
 */

/** \addtogroup fileconfig
 *  @{
 */
public class FileConfigModule : DynamicModule {
	public FileConfigModule() {
		extring nm = extring.set_static_string("fileconfig");
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring command = extring.set_static_string("command");
		Plugin.register(&command, new M100Extension(new FileConfigCommand(), this));
		extring unittest = extring.set_static_string("unittest");
		Plugin.register(&unittest, new AnyInterfaceExtension(new FileConfigTest(), this));
		return 0;
	}

	public override int deinit() {
		DefaultConfigEngine.setDefault(null);
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new FileConfigModule();
	}
}
/* @} */
