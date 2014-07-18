using aroop;
using shotodol;
using shotodol.web;

/** \addtogroup cgi
 *  @{
 */
internal class shotodol.web.CGIReaderSpindle : Spindle {
	LineInputStream is;
	protected StandardOutputStream pad;
	public CGIReaderSpindle() {
		StandardInputStream x = new StandardInputStream();
		is = new LineInputStream(x);
		pad = new StandardOutputStream();
	}
	~CGIReaderSpindle() {
	}
	public override int start(Spindle?plr) {
		//print("Started console stepping ..\n");
		
		return 0;
	}

	void parseLine(extring*cmd) {
		cmd.zero_terminate();
		extring dlg = extring.stack(64);
		dlg.printf("Parsing:%s\n", cmd.to_string());
		pad.write(&dlg);
		extring token = extring();
		LineAlign.next_token(cmd, &token);
		if(cmd.char_at(0) == '=') {
			dlg.printf("key=%s\n", token.to_string());
			pad.write(&dlg);
			dlg.printf("value=%s\n", cmd.to_string());
			pad.write(&dlg);
		}
		dlg.printf("\n");
		pad.write(&dlg);
	}

	public override int step() {
		extring inp = extring.stack(512);
		try {
			
			int available = is.availableBytes();
			if(available > 0) {
				is.read(&inp);
				if(!inp.is_empty()) {
					parseLine(&inp);
				}
			}
		} catch (IOStreamError.InputStreamError e) {
			print("Error in standard input\n");
			return 0;
		}
		inp.destroy();
		return 0;
	}

	public override int cancel() {
		return 0;
	}
}


/* @} */
