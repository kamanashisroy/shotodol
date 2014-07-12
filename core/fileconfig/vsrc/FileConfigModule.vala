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
		name = etxt.from_static("fileconfig");
	}

	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new FileConfigCommand(), this));
		txt unittest = new txt.from_static("unittest");
		Plugin.register(unittest, new AnyInterfaceExtension(new FileConfigTest(), this));
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
