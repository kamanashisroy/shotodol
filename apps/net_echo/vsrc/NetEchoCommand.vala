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
		addOptionString("-send", M100Command.OptionType.TXT, Options.BLUE_TEST_SEND, "Start sending");
		addOptionString("-echo", M100Command.OptionType.TXT, Options.BLUE_TEST_ECHO, "Start echo"); 
		addOptionString("-chunk_size", M100Command.OptionType.INT, Options.BLUE_TEST_CHUNKSIZE, "Set chunk size, it works while sending data."); 
		addOptionString("-check_content", M100Command.OptionType.NONE, Options.BLUE_TEST_CHECKCONTENT, "Check the content if valid before echoing."); 
		addOptionString("-verbose", M100Command.OptionType.NONE, Options.BLUE_TEST_VERBOSE, "Verbose data."); 
		addOptionString("-interval", M100Command.OptionType.INT, Options.BLUE_TEST_IO_INTERVAL, "Set interval in miliseconds."); 
		addOptionString("-dryrun", M100Command.OptionType.NONE, Options.BLUE_TEST_DRYRUN, "Dry run (no echo/ no sending data..)."); 
		addOptionString("-reconnect", M100Command.OptionType.NONE, Options.BLUE_TEST_RECONNECT, "Reconnect to server (see -send)."); 
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

	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		int chunkSize = 32;
		bool checkContent = false;
		bool verbose = false;
		bool dryrun = false;
		bool reconnect = false;
		int interval = 10;
		txt?arg = null;

		if(vals[Options.BLUE_TEST_DRYRUN] != null) {
			dryrun = true;
		}
		arg = vals[Options.BLUE_TEST_IO_INTERVAL];
		if(arg != null) {
			interval = arg.to_int();
			etxt dlg = etxt.stack(128);
			dlg.printf("Interval = %d\n", interval);
			pad.write(&dlg);
		}
		if(vals[Options.BLUE_TEST_CHECKCONTENT] != null) {
			checkContent = true;
		}
		if(vals[Options.BLUE_TEST_VERBOSE] != null) {
			verbose = true;
		}
		arg = vals[Options.BLUE_TEST_CHUNKSIZE];
		if(arg != null) {
			chunkSize = arg.to_int();
		}
		if(vals[Options.BLUE_TEST_RECONNECT] != null) {
			reconnect = true;
		}
		arg = vals[Options.BLUE_TEST_ECHO];
		if(arg != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo server is receiving data on %s\n", arg.to_string());
			pad.write(&dlg);
			sp = new NetEchoServer(interval, checkContent, verbose, dryrun);
			if(sp.setup(arg) != 0) {
				sp = null;
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
			}
			MainTurbine.gearup(sp);
		}
		arg = vals[Options.BLUE_TEST_SEND];
		if(arg != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("Echo client is sending data to %s\n", arg.to_string());
			pad.write(&dlg);
			sp = new NetEchoClient(chunkSize, interval, reconnect, verbose, dryrun);
			if(sp.setup(arg) != 0) {
				sp = null;
				throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
			}
			MainTurbine.gearup(sp);
		}
		return 0;
	}
}
/* @} */
