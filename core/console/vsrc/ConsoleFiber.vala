using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */
internal abstract class ConsoleFiber : Fiber {
	class ConsoleStream : PullOutputStream {
		unowned ConsoleFiber?sp;
		public ConsoleStream(InputStream x, ConsoleFiber activator) {
			base(x);
			sp = activator;
		}
		public override int write(extring*cmd) throws IOStreamError.OutputStreamError {
			cmd.zero_terminate();
			extring dlg = extring.stack(64);
			dlg.printf("Executing:%s\n", cmd.to_string());
			sp.pad.write(&dlg);
			extring serv = extring.set_static_string("command/server");
			Plugin.swarm(&serv, cmd, null);
			//CommandModule.server.cmds.act_on(cmd, pad, null);
			dlg.printf("\n");
			sp.pad.write(&dlg);
			sp.addHistory(cmd);
			return 0;
		}
	}
	LineInputStream lis;
	protected OutputStream pad;
	ConsoleStream cstrm;
	int countDown;
	public ConsoleFiber() {
		lis = new LineInputStream(new StandardInputStream());
		pad = new StandardOutputStream();
		cstrm = new ConsoleStream(lis, this);
		countDown = 0;
	}
	~ConsoleFiber() {
	}
	public void pull(InputStream x) {
		lis.close();
		lis = new LineInputStream(x);
		cstrm.pull(lis);
	}
	public abstract void showHistory();
	public abstract void addHistory(extring*cmd);
	public override int start(Fiber?plr) {
		//print("Started console stepping ..\n");
		
		return 0;
	}

	public override int step() {
		if(countDown > 0) {
			countDown--;
			return 0;
		}
		try {
			cstrm.step();
		} catch (IOStreamError.InputStreamError e) {
			print("Error in standard input\n");
			return 0;
		}
		return 0;
	}

	public override int cancel() {
		return 0;
	}

	internal void glide(int terms) {
		countDown = terms;
	}
}


/* @} */
