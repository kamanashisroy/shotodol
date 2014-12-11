using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */
internal abstract class ConsoleSpindle : Spindle {
	LineInputStream lis;
	protected OutputStream pad;
	//bool iamdeaf;
	int countDown;
	public ConsoleSpindle() {
		StandardInputStream x = new StandardInputStream();
		lis = new LineInputStream(x);
		pad = new StandardOutputStream();
		//iamdeaf = false;
		countDown = 0;
	}
	~ConsoleSpindle() {
	}
	public void setInputStream(InputStream x) {
		lis.close();
		lis = new LineInputStream(x);
	}
	public abstract void showHistory();
	public abstract void addHistory(extring*cmd);
	public override int start(Spindle?plr) {
		//print("Started console stepping ..\n");
		
		return 0;
	}

	void perform_action(extring*cmd) {
		cmd.zero_terminate();
		extring dlg = extring.stack(64);
		dlg.printf("Executing:%s\n", cmd.to_string());
		pad.write(&dlg);
		extring serv = extring.set_static_string("command/server");
		Plugin.swarm(&serv, cmd, null);
		//CommandModule.server.cmds.act_on(cmd, pad, null);
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
			extring inp = extring.stack(512);
			
			int available = lis.availableBytes();
			if(available > 0) {
				lis.read(&inp);
				if(!inp.is_empty()) {
					perform_action(&inp);
				}
			}
#if false
			if(available == 1) {
				lis.readChar(&inp, true);
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
