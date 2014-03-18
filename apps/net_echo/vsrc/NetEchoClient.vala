using aroop;
using shotodol;

internal class NetEchoClient : NetEchoService {
	shotodol_platform_net.NetStreamPlatformImpl strm;
	int chunkSize;
	etxt content;
	bool connected;
	bool verbose;
	public NetEchoClient(int givenChunkSize, bool verb) {
		strm = shotodol_platform_net.NetStreamPlatformImpl();
		chunkSize = givenChunkSize;
		verbose = verb;
		content = etxt.EMPTY();
		content.buffer(chunkSize+1);
		int i = 0;
		for(i = 0; i < chunkSize;i++) {
			content.concat_char(65); // ascii of A
		}
		content.zero_terminate();
		assertBuffer(&content);
		connected = false;
		print("Content:%s\n", content.to_string());
	}
	~NetEchoClient() {
		content.destroy();
		strm.close();
	}

	int closeClient() {
		pl.remove(&strm);
		strm.close();
		poll = false;
		return 0;
	}

	internal override int onEvent(shotodol_platform_net.NetStreamPlatformImpl*x) {
		print(" [ ~ ] Client .. \n");
		// read server data
		etxt buf = etxt.stack(1024);
		if(strm.read(&buf) <= 0) {
			closeClient();
			return -1;
		}
		buf.zero_terminate();
		if(verbose)print("[ + ] [%d] [%ld,%ld] %s\n", buf.length(), recv_bytes, sent_bytes, buf.to_string());
		else print("[ + ] [%d] [%ld,%ld]\n", buf.length(), recv_bytes, sent_bytes);
		recv_bytes += buf.length();
		return 0;
	}

	internal override int step_more() {
		if(!connected) {
			// let it connect ..
			connected = true;
		}
		// continue sending data..
		assertBuffer(&content);
		etxt buf = etxt.same_same(&content);
		buf.zero_terminate();
		if(verbose)print("[ - ] [%d] [%ld,%ld] %s\n", buf.length(), recv_bytes, sent_bytes, buf.to_string());
		else print("[ - ] [%d] [%ld,%ld]\n", buf.length(), recv_bytes, sent_bytes);
		assertBuffer(&buf);
		int ret = strm.write(&buf);
		if(ret <= 0) {
			closeClient();
			return -1;
		}
		sent_bytes += ret;
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


