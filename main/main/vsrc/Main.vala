using aroop;
using shotodol;

public class MainProgram : shotodol.Propeller {
	public static int main() {
		// TODO load lua
		// and load all the modules
		// TODO - if(opt & SHELL) then start console
		//Module.load_dynamic_module("/media/active/projects/shotodol/core/console/plugin.so");
		Module.load_dynamic_module("core/console/plugin.so");
		(new MainProgram()).start(null);
		return 0;
	}
}

