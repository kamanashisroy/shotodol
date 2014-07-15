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
		Plugin.register(command, new M100Extension(new WatchdogCommand(), this));
		txt unittest = new txt.from_static("unittest");
		Plugin.register(unittest, new AnyInterfaceExtension(new ConsoleTest(), this));
		txt onLoad = new txt.from_static("onLoad");
		Plugin.register(onLoad, new HookExtension(onLoadHook, this));
		return 0;
	}

	int onLoadHook(etxt*msg, etxt*output) {
		bool hasConsole = true;
		Bundler bndlr = Bundler();
		bndlr.buildFromEtxt(msg);
		do {
			int key = bndlr.next();
			if(key == -1) break;
			if(bndlr.getContentType() != BundledContentType.STRING_CONTENT) continue;
			etxt uarg = etxt.given_length((string)bndlr.getContent(), bndlr.getContentLength(), null);
			if(uarg.equals_string("-noconsole")) {
				hasConsole = false;
			} else if(uarg.equals_string("--help")) {
				print("-noconsole Use this argument to run the shotodol without shell.\n");
				hasConsole = false;
			}
		} while(true);
		if(!hasConsole) return 0;

		print("Loading console spindle\n");
		txt spindle = new txt.from_static("MainSpindle");
		ConsoleHistory sp = new ConsoleHistory();
		Plugin.register(spindle, new AnyInterfaceExtension(sp, this));
		txt command = new txt.from_static("command");
		Plugin.register(command, new M100Extension(new ConsoleCommand(sp), this));
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
