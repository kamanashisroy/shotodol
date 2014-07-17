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
		estr nm = estr.set_static_string("fileconfig");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new FileConfigCommand(), this));
		estr unittest = estr.set_static_string("unittest");
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
