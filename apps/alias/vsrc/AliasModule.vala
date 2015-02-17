using aroop;
using shotodol;

/**
 * \ingroup apps
 * \defgroup alias Alias module creates package for distribution
 */

/** \addtogroup alias
 *  @{
 */
public class shotodol.AliasModule : DynamicModule {
	public AliasModule() {
		extring nm = extring.set_string(core.sourceModuleName());
		extring ver = extring.set_static_string("0.0.0");
		base(&nm,&ver);
	}
	public override int init() {
		AliasCommand?cmd = new AliasCommand();
		extring entry = extring.set_static_string("command");
		PluginManager.register(&entry, new M100Extension(cmd, this));
		PluginManager.register(&entry, new M100Extension(cmd.acmd, this));
		return 0;
	}
	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new AliasModule();
	}
}
/* @} */

