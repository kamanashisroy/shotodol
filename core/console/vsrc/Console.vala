using aroop;
using shotodol;
using shotodol_platform;

public class Console : ModulePlugin {

	class ConsoleSpindle : Spindle {
		StandardInputStream is;
		StandardOutputStream pad;
		public ConsoleSpindle() {
			is = new StandardInputStream();
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
			etxt inp = etxt.stack(128);
			try {
				is.read(&inp);
			} catch (IOStreamError.InputStreamError e) {
				print("Error in standard input\n");
				return 0;
			}
			int i = 0;
			int cmd_start = 0;
			for(i=0;i<inp.length();i++) {
				if(inp.char_at(i) == '\n') {
					etxt cmd = etxt.dup_etxt(&inp);
					if(cmd_start != 0) {
						cmd.shift(cmd_start);
					}
					cmd.trim_to_length(i);
					perform_action(&cmd);
					cmd.destroy();
					cmd_start = i+1;
				}
			}
			inp.destroy();
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

