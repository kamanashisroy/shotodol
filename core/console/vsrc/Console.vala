using aroop;
using shotodol;

public class Console : Module {

	class ConsoleSpindle : Spindle {
		public override int start(Propeller?plr) {
			return 0;
		}
		public override int step() {
			print("Stepping\n");
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
		
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

