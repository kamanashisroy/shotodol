using aroop;
using shotodol;
using shotodol_platform;

public class Console : ModulePlugin {

	class ConsoleSpindle : Spindle {
		LineInputStream is;
		StandardOutputStream pad;
		public ConsoleSpindle() {
			StandardInputStream x = new StandardInputStream();
			is = new LineInputStream(x);
			pad = new StandardOutputStream();
		}
		~ConsoleSpindle() {
		}
		public override int start(Propeller?plr) {
			print("Started console stepping ..\n");
			
			return 0;
		}

		void perform_action(etxt*cmd) {
 			cmd.zero_terminate();
 			print("Executing:%s\n", cmd.to_string());
 			CommandServer.server.act_on(cmd, pad);
 			print("\n");
		}

		public override int step() {
			try {
				etxt inp = etxt.stack(128);
				if(is.read(&inp) != 0) {
					perform_action(&inp);
				}
				inp.destroy();
			} catch (IOStreamError.InputStreamError e) {
				print("Error in standard input\n");
				return 0;
			}
			return 0;
		}
		public override int cancel() {
			return 0;
		}
	}

	public override int init() {
		//base.init();
		ConsoleSpindle sp = new ConsoleSpindle();
		MainTurbine.gearup(sp);
		new Watchdog(new StandardOutputStream());
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

