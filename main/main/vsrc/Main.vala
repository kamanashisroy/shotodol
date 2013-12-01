using aroop;
using shotodol;

public class MainProgram {
	static etxt path_to_shotodol;
	static int load_core_module(string module_name) {
		load_module_helper(module_name, "core");
		return 0;
	}
	
	static int load_module_helper(string module_name, string dir) {
		print("Trying to load module %s%s/%s\n", path_to_shotodol.to_string(), dir, module_name);
		etxt path = etxt.stack(128);
		path.printf("%s%s/%s/plugin.so", path_to_shotodol.to_string(), dir, module_name);
		ModulePlugin.load_dynamic_module(path.to_string());
		print("\t\t\t\t %s module is Loaded\n", module_name);
		return 0;
	}
	
	static int preload_modules() {
		//load_module_helper("iostream", "libs");
		load_module_helper("str_arms", "libs");
		return 0;
	}
	
	static int load_module() {
		load_core_module("test");
		load_core_module("commands");
		load_core_module("console");
		load_core_module("make");
		return 0;
	}
		
	public static int main() {
		// TODO parse the argument for shotodol home
		path_to_shotodol = etxt("/media/active/projects/shotodol/");
		// TODO load lua
		// TODO - if(opt & SHELL) then start console
		MainTurbine mt = new MainTurbine();
		
		preload_modules();
		load_module();
		mt.startup();
		return 0;
	}
}

