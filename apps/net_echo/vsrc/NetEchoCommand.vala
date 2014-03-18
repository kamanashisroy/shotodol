using aroop;
using shotodol;

internal class NetEchoCommand : M100Command {
	etxt prfx;
	NetEchoService?sp;
	enum Options {
		BLUE_TEST_SEND = 1,
		BLUE_TEST_ECHO,
		BLUE_TEST_CHUNKSIZE,
		BLUE_TEST_CHECKCONTENT,
	}
	public NetEchoCommand() {
		base();
		sp = null;
		etxt send = etxt.from_static("-send");
		etxt send_help = etxt.from_static("Start sending.");
		etxt echo = etxt.from_static("-echo");
		etxt echo_help = etxt.from_static("Start echo.");
		etxt chunk_size = etxt.from_static("-chunk_size");
		etxt chunk_size_help = etxt.from_static("Set chunk size, it works while sending data.");
		etxt check_content = etxt.from_static("-check_content");
		etxt check_content_help = etxt.from_static("Check the content if valid before echoing.");
		addOption(&send, M100Command.OptionType.TXT, Options.BLUE_TEST_SEND, &send_help);
		addOption(&echo, M100Command.OptionType.TXT, Options.BLUE_TEST_ECHO, &echo_help); 
		addOption(&chunk_size, M100Command.OptionType.TXT, Options.BLUE_TEST_CHUNKSIZE, &chunk_size_help); 
		addOption(&check_content, M100Command.OptionType.TXT, Options.BLUE_TEST_CHECKCONTENT, &check_content_help); 
	}

	~NetEchoCommand() {
		if(sp != null) {
			MainTurbine.geardown(sp);
			sp = null;
		}
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("net_echo");
		return &prfx;
	}

	public override int act_on(etxt*cmdstr, OutputStream pad) {
		greet(pad);
		SearchableSet<txt> vals = SearchableSet<txt>();
		parseOptions(cmdstr, &vals);
		int chunkSize = 32;
		bool checkContent = true;
		container<txt>? mod;

		mod = vals.search(Options.BLUE_TEST_CHECKCONTENT, match_all);
		if(mod != null) {
			checkContent = true;
		}
		mod = vals.search(Options.BLUE_TEST_CHUNKSIZE, match_all);
		if(mod != null) {
			chunkSize = mod.get().to_int();
		}
		mod = vals.search(Options.BLUE_TEST_ECHO, match_all);
		if(mod != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo server is receiving data on %s\n", mod.get().to_string());
			pad.write(&dlg);
			sp = new NetEchoServer(checkContent);
			if(sp.setup(mod.get()) != 0) {
				sp = null;
				bye(pad, false);
				return 0;
			}
			MainTurbine.gearup(sp);
		}
		mod = vals.search(Options.BLUE_TEST_SEND, match_all);
		if(mod != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo client is sending data to %s\n", mod.get().to_string());
			pad.write(&dlg);
			sp = new NetEchoClient(chunkSize);
			if(sp.setup(mod.get()) != 0) {
				sp = null;
				bye(pad, false);
				return 0;
			}
			MainTurbine.gearup(sp);
		}
		bye(pad, true);
		return 0;
	}
}
