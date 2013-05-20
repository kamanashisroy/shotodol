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
		public override int step() {
			fileio x = fileio.stdin();
			etxt cmd = etxt.stack(128);
 			x.read(&cmd);
 			cmd.zero_terminate();
 			print("Executing:%s\n", cmd.to_string());
 			CommandServer.server.act_on(&cmd, io);
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
		ConsoleSpindle sp = new ConsoleSpindle();
		MainTurbine.gearup(sp);
		return 0;
	}

	[CCode (cname="get_module_instance")]
	public static Module get_module_instance() {
		return new Console();
	}
}

