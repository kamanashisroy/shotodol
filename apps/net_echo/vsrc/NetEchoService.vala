using aroop;
using shotodol;

internal abstract class NetEchoService : NetEchoSpindle {
	protected long recv_bytes;
	protected long sent_bytes;
	public NetEchoService() {
		base();
		recv_bytes = 0;
		sent_bytes = 0;
	}
	~NetEchoService() {
	}
}


