using aroop;
using shotodol;

internal class NetEchoServer : NetEchoService {
	bool waiting;
	bool checkContent;
	bool dryrun;
	bool verbose;
	shotodol_platform_net.NetStreamPlatformImpl server;
	shotodol_platform_net.NetStreamPlatformImpl client;
	public NetEchoServer(int givenInterval, bool shouldCheckContent, bool verb, bool shouldDryrun) {
		base();
		verbose = verb;
		dryrun = shouldDryrun;
		interval = givenInterval;
		server = shotodol_platform_net.NetStreamPlatformImpl();
		client = shotodol_platform_net.NetStreamPlatformImpl();
		waiting = true;
		checkContent = shouldCheckContent;
	}

	~NetEchoServer() {
		server.close();
		client.close();
	}

	int closeClient() {
		print("Closing client [%ld,%ld]\n", recv_bytes, sent_bytes);
		pl.remove(&client);
		client.close();
		waiting = true;
		poll = false;
		return 0;
	}

	internal override int onEvent(shotodol_platform_net.NetStreamPlatformImpl*x) {
		print("[ ~ ] Server\n");
		if(waiting) {
			// accept client
			print("Accepting new client [%ld,%ld]\n", recv_bytes, sent_bytes);
			client.accept(&server);
			pl.add(&client);
			pl.remove(&server);
			//server.close();
			waiting = false;
			return -1;
		}
		if(x != &client) {
			print("[ ~ ] Strange\n");
			return 0;
		}
		// echo client data
		etxt buf = etxt.stack(1024);
		if(x.read(&buf) <= 0) {
			//pl.add(&server);
			closeClient();
			print("Removed client [%ld,%ld]\n", recv_bytes, sent_bytes);
			return -1;
		}
		recv_bytes += buf.length();
		buf.zero_terminate();
		if(verbose)
			print("[ + ] [%d] [%ld,%ld] - %d,%d\n", buf.length(), recv_bytes, sent_bytes, buf.char_at(0), buf.char_at(8));
		else
			print("[ + ] [%d] [%ld,%ld]\n", buf.length(), recv_bytes, sent_bytes);
#if false
		int i = buf.length() - 1;
		buf.trim_to_length(0);
		for(;i >= 0;i--) {
			buf.concat_char(97);
		}
#endif
		if(checkContent)assertBuffer(&buf);
		if(dryrun) {
			return 0;
		}
		int ret = x.write(&buf);
		if(ret <= 0) {
			closeClient();
			return -1;
		}
		sent_bytes += ret;
		print("[ - ] [%d] [%ld,%ld]\n", ret, recv_bytes, sent_bytes);
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


