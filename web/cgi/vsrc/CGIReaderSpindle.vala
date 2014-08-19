using aroop;
using shotodol;
using shotodol.web;

/** \addtogroup cgi
 *  @{
 */
internal class shotodol.web.CGIReaderSpindle : Spindle {
	enum cgiRequest {
		REQUEST_METHOD = 1,
		REQUEST_URL,
		REQUEST_VERSION,
		REQUEST_KEY,
		REQUEST_VALUE,
	}
	LineInputStream is;
	protected StandardOutputStream pad;
	extring colonSign;
	Renu?header;
	Bundler bndlr;
	int lineNumber;
	bool endOfParsing;
	extring url;
	public CGIReaderSpindle() {
		StandardInputStream x = new StandardInputStream();
		is = new LineInputStream(x);
		pad = new StandardOutputStream();
		colonSign = extring.set_static_string(":");
		Bundler bndlr = Bundler();
		header = null;
		lineNumber = 0;
		endOfParsing = false;
		url = extring();
	}
	~CGIReaderSpindle() {
	}
	public override int start(Spindle?plr) {
		// do late initialization here ..
		RenuFactory? renuBuilder = null;
		extring ex = extring.set_static_string("renu/factory");
		Plugin.acceptVisitor(&ex, (x) => {
			renuBuilder = (RenuFactory)x.getInterface(null);
		});
		if(renuBuilder == null) {
			print("Could not get renu factory\n");
			// fatal error
			return -1;
		}
		header = renuBuilder.createRenu(1024);
		bndlr.buildFromCarton(&header.msg, header.size);
		return 0;
	}

	void notifyPageHook() {
		extring page = extring.stack(url.length()+8);
		page.concat_string("page/");
		page.concat(&url);
		extring status = extring();
		extring headerXtring = extring();
		header.getTaskAs(&headerXtring);
		Plugin.swarm(&page, &headerXtring, &status);
	}

	void parseFirstLine(extring*cmd) {
		extring token = extring();
		LineAlign.next_token(cmd, &token);
		bndlr.writeEXtring(cgiRequest.REQUEST_METHOD, &token);
		LineAlign.next_token(cmd, &token);
		bndlr.writeEXtring(cgiRequest.REQUEST_URL, &token);
		bndlr.writeEXtring(cgiRequest.REQUEST_VERSION, cmd);
		url.rebuild_in_heap(token.length()+1);
		url.concat(&token);
		lineNumber++;
	}

	void parseLine(extring*cmd) {
		if(lineNumber == 0) {
			parseFirstLine(cmd);
			return;
		}
		cmd.zero_terminate();
		extring token = extring();
		LineAlign.next_token_delimitered(cmd, &token, &colonSign);
		if(cmd.char_at(0) == '=') {
			bndlr.writeEXtring(cgiRequest.REQUEST_KEY, &token);
			bndlr.writeEXtring(cgiRequest.REQUEST_VALUE, cmd);
		}
		lineNumber++;
	}

	public override int step() {
		if(endOfParsing)
			return 0;
		extring inp = extring.stack(512);
		try {
			
			int available = is.availableBytes();
			if(available > 0) {
				is.read(&inp);
				if(!inp.is_empty()) {
					parseLine(&inp);
				} else {
					print("End of header\n");
					header.finalize(&bndlr);
					endOfParsing = true;
					notifyPageHook();
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
