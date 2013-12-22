using aroop;
using shotodol;

public errordomain IOStreamError.NetStreamError {
	NET_NOT_SUPPORTED,
}
public abstract class shotodol.NetStream : Replicable {
	enum ConnectFlags {
		BIND = 1,
		UDP = 1<<1,
		TCP = 1<<2,
	}
	public NetStream();
	public abstract void connect(etxt*path, aroop_uword8 flags) throws IOStreamError.NetStreamError;
	public abstract InputStream getInputStream() throws IOStreamError.NetStreamError;
	public abstract OutputStream getOutputStream() throws IOStreamError.NetStreamError;
	public abstract int close();
}
