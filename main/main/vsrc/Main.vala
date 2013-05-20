using aroop;
using shotodol;

public class MainProgram {
	
	static int load_core_module(string module_name) {
		print("Trying to load module %s\n", module_name);
		etxt path = etxt.stack(64);
		path.printf("core/%s/plugin.so",module_name);
		Module.load_dynamic_module(path.to_string());
		print("\t\t\t\t %s module is Loaded\n", module_name);
		return 0;
	}
	
	static int preload_modules() {
		Module.load_dynamic_module("libs/iostream/plugin.so");
		Module.load_dynamic_module("libs/str_arms/plugin.so");
		return 0;
	}
	
	static int load_module() {
		load_core_module("commands");
		load_core_module("console");
		//Module.load_dynamic_module("core/commands/plugin.so");
		//Module.load_dynamic_module("core/console/plugin.so");
		
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

