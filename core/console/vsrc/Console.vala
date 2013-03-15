using aroop;
using shotodol;
using shotodol_platform;

public class Console : Module {

	class ConsoleSpindle : Spindle {
		
		public ConsoleSpindle() {
		}
		~ConsoleSpindle() {
		}
		public override int start(Propeller?plr) {
			print("Started stepping console ..\n");
			
			return 0;
		}
		public override int step() {
			fileio x = fileio.stdin();
			etxt cmd = etxt.stack(128);
 			x.read(&cmd);
 			cmd.zero_terminate();
 			print("Read:%s\n", cmd.to_string());
 			print("\n");
 			// TODO see what the command is
			return 0;
		}
		public override int cancel() {
			return 0;
		}
	}

	public override int init() {
		//base.init();
		print("Loading console\n");
		ConsoleSpindle sp = new ConsoleSpindle();
		MainTurbine.gearup(sp);
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

