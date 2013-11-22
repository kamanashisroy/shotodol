using aroop;
using shotodol;
using shotodol_platform;

public class Console : Module {

	class ConsoleSpindle : Spindle {
		StandardIO io;
		public ConsoleSpindle() {
			io = new StandardIO();
		}
		~ConsoleSpindle() {
			io = null;
		}
		public override int start(Propeller?plr) {
			print("Started console stepping ..\n");
			
			return 0;
		}

		void perform_action(etxt*cmd) {
 			cmd.zero_terminate();
 			print("Executing:%s\n", cmd.to_string());
 			CommandServer.server.act_on(cmd, io);
 			print("\n");
		}

		public override int step() {
			fileio x = fileio.stdin();
			etxt inp = etxt.stack(128);
 			if(x.read(&inp) == 0) {
				return -1;
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
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

