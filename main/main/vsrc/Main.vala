using aroop;
using shotodol;

public class MainProgram {
	static int preload_modules() {
		return 0;
	}
	static int load_module() {
		Module.load_dynamic_module("core/commands/plugin.so");
		Module.load_dynamic_module("core/console/plugin.so");
		
		return 0;
	}
	public static int main() {
		// TODO load lua
		// and load all the modules
		// TODO - if(opt & SHELL) then start console
		MainTurbine mt = new MainTurbine();
		
		preload_modules();
		load_module();
		mt.startup();
		return 0;
	}
}

