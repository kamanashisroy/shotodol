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
		estr nm = estr.set_static_string("console");
		estr ver = estr.set_static_string("0.0.0");
		base(&nm,&ver);
	}

	public override int init() {
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new WatchdogCommand(), this));
		estr unittest = estr.set_static_string("unittest");
		Plugin.register(&unittest, new AnyInterfaceExtension(new ConsoleTest(), this));
		estr onLoad = estr.set_static_string("onLoad");
		Plugin.register(&onLoad, new HookExtension(onLoadHook, this));
		return 0;
	}

	int onLoadHook(estr*msg, estr*output) {
		bool hasConsole = true;
		Bundler bndlr = Bundler();
		bndlr.buildFromEstr(msg);
		do {
			int key = bndlr.next();
			if(key == -1) break;
			if(bndlr.getContentType() != BundledContentType.STRING_CONTENT) continue;
			estr uarg = estr.set_content((string)bndlr.getContent(), bndlr.getContentLength());
			if(uarg.equals_string("-noconsole")) {
				hasConsole = false;
			} else if(uarg.equals_string("--help")) {
				print("-noconsole Use this argument to run the shotodol without shell.\n");
				hasConsole = false;
			}
		} while(true);
		if(!hasConsole) return 0;

		print("Loading console spindle\n");
		estr spindle = estr.set_static_string("MainSpindle");
		ConsoleHistory sp = new ConsoleHistory();
		Plugin.register(&spindle, new AnyInterfaceExtension(sp, this));
		estr command = estr.set_static_string("command");
		Plugin.register(&command, new M100Extension(new ConsoleCommand(sp), this));
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
