using aroop;
using shotodol;
using shotodol_platform;

/**
 * \ingroup core
 * \defgroup console Console command support(console)
 */
/** \addtogroup console
 *  @{
 */
public class ConsoleModule : DynamicModule {

	public ConsoleModule() {
		name = etxt.from_static("console");
	}

	public override int init() {
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new ConsoleCommand(), this));
		Plugin.register(command, new M100Extension(new WatchdogCommand(), this));
		txt unittest = new txt.from_static("unittest");
		Plugin.register(unittest, new AnyInterfaceExtension(new ConsoleTest(), this));
		return 0;
	}

	public override int deinit() {
		base.deinit();
		return 0;
	}
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new ConsoleModule();
	}
}

/* @} */
