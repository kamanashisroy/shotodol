using aroop;
using shotodol;

internal class BlueTestCommand : M100Command {
	class BlueTestSpindle : Spindle {
		bool poll;
		bool server_mode;
		bool waiting;
		shotodol_platform_net.NetStreamPlatformImpl strm;
		shotodol_platform_net.NetStreamPlatformImpl client;
		shotodol_platform_net.NetStreamPollPlatformImpl pl;
		etxt sco_prefix;
		long recv_bytes;
		long sent_bytes;
		public BlueTestSpindle() {
			sco_prefix = etxt.from_static("SCO://");
			strm = shotodol_platform_net.NetStreamPlatformImpl();
			client = shotodol_platform_net.NetStreamPlatformImpl();
			pl = shotodol_platform_net.NetStreamPollPlatformImpl();
			poll = false;
			server_mode = false;
			recv_bytes = 0;
			sent_bytes = 0;
			waiting = true;
		}
		~BlueTestSpindle() {
		}
		public override int start(Spindle?plr) {
			print("Prepare bluetooth server ..\n");
			return 0;
		}

		int runClient(shotodol_platform_net.NetStreamPlatformImpl*x) {
			// read server data
			etxt buf = etxt.stack(1024);
			if(strm.read(&buf) <= 0) {
				pl.remove(&strm);
				strm.close();
				poll = false;
				return -1;
			}
			recv_bytes += buf.length();
			return 0;
		}

		int runServer(shotodol_platform_net.NetStreamPlatformImpl*x) {
			if(waiting) {
				// accept client
				print("Accepting new client [%ld,%ld]\n", recv_bytes, sent_bytes);
				client.accept(&strm);
				pl.add(&client);
				pl.remove(&strm);
				waiting = false;
				return -1;
			}
			// echo client data
			etxt buf = etxt.stack(1024);
			if(x.read(&buf) <= 0) {
				//pl.add(&strm);
				pl.remove(x);
				x.close();
				poll = false;
				print("Removed client [%ld,%ld]\n", recv_bytes, sent_bytes);
				return -1;
			}
			recv_bytes += buf.length();
			sent_bytes += x.write(&buf);
			if(buf.length() != 0) {
				print("link is stalled !\n");
			}
			return 0;
		}

		public override int step() {
			if(!poll) {
				return 0;
			}
			pl.check_events();
			do {
				shotodol_platform_net.NetStreamPlatformImpl*x = pl.next();
				if(x == null) {
					break;
				}
				print("Interesting [%ld,%ld]\n", recv_bytes, sent_bytes);
				if(server_mode) {
					if(runServer(x)!=0) {
						break;
					}
				} else {
					if(runClient(x)!=0) {
						break;
					}
				}
			} while(true);
			if(poll && !server_mode) {
				// continue sending data..
				etxt buf = etxt.from_static("Great");
				sent_bytes += strm.write(&buf);
				if(buf.length() != 0) {
					print("link is stalled !\n");
				}
			}
			return 0;
		}
		public override int cancel() {
			return 0;
		}
		internal int recv(etxt*addr) {
			etxt scoaddr = etxt.stack(128);
			scoaddr.concat(&sco_prefix);
			scoaddr.concat(addr);
			scoaddr.trim_to_length(23);
			scoaddr.zero_terminate();
			int ret = strm.connect(&scoaddr, shotodol_platform_net.ConnectFlags.BIND);
			scoaddr.destroy();
			if(ret == 0) {
				print("Starting server ..\n");
				pl.add(&strm);
				poll = true;
				server_mode = true;
			}
			return ret;
		}
		internal int send(etxt*addr) {
			etxt scoaddr = etxt.stack(128);
			scoaddr.concat(&sco_prefix);
			scoaddr.concat(addr);
			scoaddr.trim_to_length(41);
			scoaddr.zero_terminate();
			int ret = strm.connect(&scoaddr, shotodol_platform_net.ConnectFlags.CONNECT);
			scoaddr.destroy();
			if(ret == 0) {
				print("Starting client ..\n");
				pl.add(&strm);
				poll = true;
				server_mode = false;
			}
			return ret;
		}
	}

	etxt prfx;
	BlueTestSpindle sp;
	enum Options {
		BLUE_TEST_SEND = 1,
		BLUE_TEST_RECV,
	}
	public BlueTestCommand() {
		base();
		sp = new BlueTestSpindle();
		MainTurbine.gearup(sp);
		etxt send = etxt.from_static("-send");
		etxt send_help = etxt.from_static("Start sending");
		etxt recv = etxt.from_static("-recv");
		etxt recv_help = etxt.from_static("Start receiving");
		addOption(&send, M100Command.OptionType.TXT, Options.BLUE_TEST_SEND, &send_help);
		addOption(&recv, M100Command.OptionType.TXT, Options.BLUE_TEST_RECV, &recv_help); 
	}

	~BlueTestCommand() {
		MainTurbine.geardown(sp);
	}

	public override etxt*get_prefix() {
		prfx = etxt.from_static("bluetest");
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
			dlg.printf("bluetooth is receiving data on %s\n", mod.get().to_string());
			pad.write(&dlg);
			if(sp.recv(mod.get()) != 0) {
				bye(pad, false);
				return 0;
			}
		}
		mod = vals.search(Options.BLUE_TEST_SEND, match_all);
		if(mod != null) {
			etxt dlg = etxt.stack(128);
			dlg.printf("bluetooth is sending data to %s\n", mod.get().to_string());
			pad.write(&dlg);
			if(sp.send(mod.get()) != 0) {
				bye(pad, false);
				return 0;
			}
		}
		bye(pad, true);
		return 0;
	}
}
