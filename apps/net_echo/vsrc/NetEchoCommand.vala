using aroop;
using shotodol;

/** \addtogroup net_echo
 *  @{
 */
internal class shotodol.NetEchoCommand : M100Command {
	etxt prfx;
	NetEchoService?sp;
	enum Options {
		BLUE_TEST_SEND = 1,
		BLUE_TEST_ECHO,
		BLUE_TEST_CHUNKSIZE,
		BLUE_TEST_CHECKCONTENT,
		BLUE_TEST_VERBOSE,
		BLUE_TEST_IO_INTERVAL,
		BLUE_TEST_DRYRUN,
		BLUE_TEST_RECONNECT,
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
		etxt verbose = etxt.from_static("-verbose");
		etxt verbose_help = etxt.from_static("Verbose data.");
		etxt interval = etxt.from_static("-interval");
		etxt interval_help = etxt.from_static("Set interval in miliseconds.");
		etxt dryrun = etxt.from_static("-dryrun");
		etxt dryrun_help = etxt.from_static("Dry run (no echo/ no sending data..).");
		etxt reconnect = etxt.from_static("-reconnect");
		etxt reconnect_help = etxt.from_static("Reconnect to server (see -send).");
		addOption(&send, M100Command.OptionType.TXT, Options.BLUE_TEST_SEND, &send_help);
		addOption(&echo, M100Command.OptionType.TXT, Options.BLUE_TEST_ECHO, &echo_help); 
		addOption(&chunk_size, M100Command.OptionType.INT, Options.BLUE_TEST_CHUNKSIZE, &chunk_size_help); 
		addOption(&check_content, M100Command.OptionType.NONE, Options.BLUE_TEST_CHECKCONTENT, &check_content_help); 
		addOption(&verbose, M100Command.OptionType.NONE, Options.BLUE_TEST_VERBOSE, &verbose_help); 
		addOption(&interval, M100Command.OptionType.INT, Options.BLUE_TEST_IO_INTERVAL, &interval_help); 
		addOption(&dryrun, M100Command.OptionType.NONE, Options.BLUE_TEST_DRYRUN, &dryrun_help); 
		addOption(&reconnect, M100Command.OptionType.NONE, Options.BLUE_TEST_RECONNECT, &reconnect_help); 
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

	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		SearchableSet<txt> vals = SearchableSet<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		int chunkSize = 32;
		bool checkContent = false;
		bool verbose = false;
		bool dryrun = false;
		bool reconnect = false;
		container<txt>? mod;
		int interval = 10;

		mod = vals.search(Options.BLUE_TEST_DRYRUN, match_all);
		if(mod != null) {
			dryrun = true;
		}
		mod = vals.search(Options.BLUE_TEST_IO_INTERVAL, match_all);
		if(mod != null) {
			interval = mod.get().to_int();
			etxt dlg = etxt.stack(128);
			dlg.printf("Interval = %d\n", interval);
			pad.write(&dlg);
		}
		mod = vals.search(Options.BLUE_TEST_CHECKCONTENT, match_all);
		if(mod != null) {
			checkContent = true;
		}
		mod = vals.search(Options.BLUE_TEST_VERBOSE, match_all);
		if(mod != null) {
			verbose = true;
		}
		mod = vals.search(Options.BLUE_TEST_CHUNKSIZE, match_all);
		if(mod != null) {
			chunkSize = mod.get().to_int();
		}
		mod = vals.search(Options.BLUE_TEST_RECONNECT, match_all);
		if(mod != null) {
			reconnect = true;
		}
		mod = vals.search(Options.BLUE_TEST_ECHO, match_all);
		if(mod != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo server is receiving data on %s\n", mod.get().to_string());
			pad.write(&dlg);
			sp = new NetEchoServer(interval, checkContent, verbose, dryrun);
			if(sp.setup(mod.get()) != 0) {
				sp = null;
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
			}
			MainTurbine.gearup(sp);
		}
		mod = vals.search(Options.BLUE_TEST_SEND, match_all);
		if(mod != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo client is sending data to %s\n", mod.get().to_string());
			pad.write(&dlg);
			sp = new NetEchoClient(chunkSize, interval, reconnect, verbose, dryrun);
			if(sp.setup(mod.get()) != 0) {
				sp = null;
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
			}
			MainTurbine.gearup(sp);
		}
		return 0;
	}
}
/* @} */
