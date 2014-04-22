using aroop;
using shotodol;

/** \addtogroup console
 *  @{
 */
internal abstract class ConsoleSpindle : Spindle {
	LineInputStream is;
	protected StandardOutputStream pad;
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
	public abstract void showHistory();
	public abstract void addHistory(etxt*cmd);
	public override int start(Spindle?plr) {
		//print("Started console stepping ..\n");
		
		return 0;
	}

	void perform_action(etxt*cmd) {
		cmd.zero_terminate();
		etxt dlg = etxt.stack(64);
		dlg.printf("Executing:%s\n", cmd.to_string());
		pad.write(&dlg);
		CommandServer.server.act_on(cmd, pad);
		dlg.printf("\n");
		pad.write(&dlg);
		addHistory(cmd);
	}

	public override int step() {
		//if(iamdeaf) {
		if(countDown > 0) {
			countDown--;
			return 0;
		}
		try {
			etxt inp = etxt.stack(512);
			
			int available = is.available_bytes();
			if(available > 0) {
				is.read(&inp);
				if(!inp.is_empty()) {
					perform_action(&inp);
				}
			}
#if false
			if(available == 1) {
				is.readChar(&inp, true);
				if(inp.length() == 1 && inp.char_at(inp.length()-1) == 72) { // left:75 right:77 down:80 up:72
					showHistory();
					return 0;
				}
			}
#endif
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


/* @} */
