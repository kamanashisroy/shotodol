using aroop;
using shotodol;

/** \addtogroup net_echo
 *  @{
 */
internal class shotodol.NetEchoClient : NetEchoService {
	shotodol_platform_net.NetStreamPlatformImpl strm;
	int chunkSize;
	etxt content;
	bool recvd;
	bool verbose;
	bool dryrun;
	int blindSend;
	bool reconnect;
	etxt scoaddr;
	public NetEchoClient(int givenChunkSize, int givenInterval, bool givenReconnect, bool verb, bool shouldDryrun) {
		base();
		scoaddr = etxt.EMPTY();
		blindSend = 40;
		chunkSize = givenChunkSize;
		interval = givenInterval;
		reconnect = givenReconnect;
		verbose = verb;
		dryrun = shouldDryrun;
		strm = shotodol_platform_net.NetStreamPlatformImpl();
		content = etxt.EMPTY();
		content.buffer(chunkSize+1);
		int i = 0;
		for(i = 0; i < chunkSize;i++) {
			content.concat_char(65); // ascii of A
		}
		content.zero_terminate();
		assertBuffer(&content);
		recvd = false;
		print("Content:%s\n", content.to_string());
	}
	~NetEchoClient() {
		scoaddr.destroy();
		content.destroy();
		strm.close();
	}

	int closeClient() {
		pl.remove(&strm);
		strm.close();
		poll = false;
		recvd = false;
		if(reconnect)connect();
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
		recvd = true;
		return 0;
	}

	internal override int step_more() {
		if(!recvd) {
			if(blindSend < 0) {
				return 0;
			}
			blindSend--;
		}
		if(dryrun) {
			return 0;
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
		recvd = false;
		return 0;
	}

	internal int connect() {
		int ret = strm.connect(&scoaddr, shotodol_platform_net.ConnectFlags.CONNECT);
		if(ret == 0) {
			print("Starting client ..\n");
			pl.add(&strm);
			poll = true;
			recvd = true;
		}
		return ret;
	}

	internal override int setup(etxt*addr) {
		scoaddr.buffer(addr.length());
		scoaddr.concat(addr);
		//scoaddr.trim_to_length(41);
		scoaddr.zero_terminate();
		return connect();
	}
}

/* @} */

