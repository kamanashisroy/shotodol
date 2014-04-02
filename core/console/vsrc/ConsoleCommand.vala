using aroop;
using shotodol;

internal class shotodol.ConsoleCommand : shotodol.M100Command {
	class ConsoleSpindle : Spindle {
		LineInputStream is;
		StandardOutputStream pad;
		//bool iamdeaf;
		int countDown;
		public ConsoleSpindle() {
			StandardInputStream x = new StandardInputStream();
			is = new LineInputStream(x);
			pad = new StandardOutputStream();
			//iamdeaf = false;
			countDown = 0;
		}
		~ConsoleSpindle() {
		}
		public override int start(Spindle?plr) {
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
			//if(iamdeaf) {
			if(countDown > 0) {
				countDown--;
				return 0;
			}
			try {
				etxt inp = etxt.stack(512);
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

		//internal void deafen() {
			// XXX we shoud have used cancel here
			//iamdeaf = true;
		//}
		internal void glide(int terms) {
			countDown = terms;
		}
	}


	etxt prfx;
	ConsoleSpindle sp;
	public ConsoleCommand() {
		base();
		sp = new ConsoleSpindle();
		MainTurbine.gearup(sp);
	}

	~ConsoleCommand() {
		MainTurbine.geardown(sp);
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("glide");
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		sp.glide(100);
		bye(pad, true);
		return 0;
	}
}
