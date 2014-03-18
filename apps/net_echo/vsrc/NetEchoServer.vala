using aroop;
using shotodol;

internal class NetEchoServer : NetEchoService {
	bool waiting;
	shotodol_platform_net.NetStreamPlatformImpl server;
	shotodol_platform_net.NetStreamPlatformImpl client;
	public NetEchoServer() {
		base();
		server = shotodol_platform_net.NetStreamPlatformImpl();
		client = shotodol_platform_net.NetStreamPlatformImpl();
		waiting = true;
	}

	~NetEchoServer() {
		server.close();
		client.close();
	}

	internal override int onEvent(shotodol_platform_net.NetStreamPlatformImpl*x) {
		if(waiting) {
			// accept client
			print("Accepting new client [%ld,%ld]\n", recv_bytes, sent_bytes);
			client.accept(&server);
			pl.add(&client);
			pl.remove(&server);
			waiting = false;
			return -1;
		}
		print("(S)Reading [%ld,%ld]\n", recv_bytes, sent_bytes);
		// echo client data
		etxt buf = etxt.stack(1024);
		if(x.read(&buf) <= 0) {
			//pl.add(&server);
			pl.remove(x);
			x.close();
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

	internal override int setup(etxt*addr) {
		etxt scoaddr = etxt.stack(128);
		scoaddr.concat(addr);
		//scoaddr.trim_to_length(23);
		scoaddr.zero_terminate();
		int ret = server.connect(&scoaddr, shotodol_platform_net.ConnectFlags.BIND);
		scoaddr.destroy();
		if(ret == 0) {
			print("Starting server ..\n");
			pl.add(&server);
			poll = true;
		}
		return ret;
	}
}


