using aroop;
using shotodol;

internal class NetEchoCommand : M100Command {
	etxt prfx;
	NetEchoService?sp;
	enum Options {
		BLUE_TEST_SEND = 1,
		BLUE_TEST_RECV,
	}
	public NetEchoCommand() {
		base();
		sp = null;
		etxt send = etxt.from_static("-send");
		etxt send_help = etxt.from_static("Start sending");
		etxt recv = etxt.from_static("-recv");
		etxt recv_help = etxt.from_static("Start receiving");
		addOption(&send, M100Command.OptionType.TXT, Options.BLUE_TEST_SEND, &send_help);
		addOption(&recv, M100Command.OptionType.TXT, Options.BLUE_TEST_RECV, &recv_help); 
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
		container<txt>? mod;
		mod = vals.search(Options.BLUE_TEST_RECV, match_all);
		if(mod != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo server is receiving data on %s\n", mod.get().to_string());
			pad.write(&dlg);
			sp = new NetEchoServer();
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
			sp = new NetEchoClient();
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
