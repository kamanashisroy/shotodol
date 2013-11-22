using aroop;
using shotodol;

internal class shotodol.DBCommand : Command {
	etxt prfx;
	public DBCommand() {
		CommandServer.server.cmds.register(this);
	}
	~DBCommand() {
		CommandServer.server.cmds.unregister(this);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("db");
		return &prfx;
	}
	int test() {
		DBEntry entry = DBEntryFactory.createEntry();
		entry.addInt(1, 10);
		entry.close();
		etxt t = etxt.from_static("test");
		MemoryDB db = new MemoryDB(DB.DBType.DB_IS_LOCAL, &t);
		DBId id = DBId();
		id.hash = 10;
		db.save(id, entry);
		return 0;
	}
	public override int act_on(/*ArrayList<txt> tokens*/etxt*cmdstr, StandardIO io) {
		io.say_static("<db command> -------------------------------------------------------\n");
		
		etxt inp = etxt.stack_from_etxt(cmdstr);
		int i = 0;
		for(i = 0; i < 32; i++) {
			etxt token = etxt.EMPTY();
			LineAlign.next_token(&inp, &token); // second token
			//token.zero_terminate();
			if(token.is_empty()) {
				break;
			}
			if(i == 0) {
				// skip command(help) argument
				continue;
			}
			etxt ntoken = etxt.stack_from_etxt(&token);
			ntoken.zero_terminate();
			io.say_static("<inserting test data ..> -------------------------------------------------------\n");
			test();
		}
		return 0;
	}
}

