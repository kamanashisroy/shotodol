using aroop;
using shotodol;
using shotodol_platform;

/**
 * \ingroup core
 * \defgroup fileconfig File based config engine 
 */

/** \addtogroup fileconfig
 *  @{
 */
public class FileConfigModule : DynamicModule {
	public FileConfigModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		extring entry = extring.set_static_string("config/server");
		PluginManager.register(&entry, new ConfigExtension(this));
		entry.rebuild_and_set_static_string("command");
		PluginManager.register(&entry, new M100Extension(new FileConfigCommand(), this));
		entry.rebuild_and_set_static_string("unittest");
		PluginManager.register(&entry, new AnyInterfaceExtension(new FileConfigTest(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new FileConfigModule();
	}
}
/* @} */
