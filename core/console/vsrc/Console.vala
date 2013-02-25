using aroop;
using shotodol;

public class Console : Module {

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		print("Things are working !\n");
		return new Console();
	}
}

