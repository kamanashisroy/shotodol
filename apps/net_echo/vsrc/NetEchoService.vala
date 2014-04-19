using aroop;
using shotodol;

/** \addtogroup net_echo
 *  @{
 */
internal abstract class shotodol.NetEchoService : NetEchoSpindle {
	protected long recv_bytes;
	protected long sent_bytes;
	public NetEchoService() {
		base();
		recv_bytes = 0;
		sent_bytes = 0;
	}
	~NetEchoService() {
	}
	protected void assertBuffer(etxt*buf) {
		core.assert(buf.char_at(0) == 65);
	}
}

/* @} */

