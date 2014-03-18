using aroop;
using shotodol;

internal class NetEchoClient : NetEchoService {
	shotodol_platform_net.NetStreamPlatformImpl strm;
	public NetEchoClient() {
		strm = shotodol_platform_net.NetStreamPlatformImpl();
	}
	~NetEchoClient() {
		strm.close();
	}

	internal override int onEvent(shotodol_platform_net.NetStreamPlatformImpl*x) {
		print("(C)Reading [%ld,%ld]\n", recv_bytes, sent_bytes);
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

	internal override int step_more() {
		// continue sending data..
		print("(C)Sending [%ld,%ld]\n", recv_bytes, sent_bytes);
		etxt buf = etxt.from_static("Great");
		sent_bytes += strm.write(&buf);
		if(buf.length() != 0) {
			print("link is stalled !\n");
		}
		return 0;
	}

	internal override int setup(etxt*addr) {
		etxt scoaddr = etxt.stack(128);
		scoaddr.concat(addr);
		//scoaddr.trim_to_length(41);
		scoaddr.zero_terminate();
		int ret = strm.connect(&scoaddr, shotodol_platform_net.ConnectFlags.CONNECT);
		scoaddr.destroy();
		if(ret == 0) {
			print("Starting client ..\n");
			pl.add(&strm);
			poll = true;
		}
		return ret;
	}
}


