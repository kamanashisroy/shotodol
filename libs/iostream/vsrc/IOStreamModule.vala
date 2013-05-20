using aroop;
using shotodol;

public class shotodol.IOStreamModule: Module {
	public IOStreamModule() {
	}
	public override int init() {
		return 0;
	}
	public override int deinit() {
		return 0;
	}
	
	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new IOStreamModule();
	}
}

