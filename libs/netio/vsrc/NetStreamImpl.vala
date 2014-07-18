using aroop;
using shotodol;
using shotodol_platform_net;

/** \addtogroup netstream
 *  @{
 */
public class shotodol.NetStreamImpl : NetStream {
	class NetInputStream :	InputStream {
		NetStreamPlatformImpl impl;
		protected NetInputStream(NetStreamPlatformImpl myPlat) {
			impl = myPlat;
		}
		public override int read(extring*buf) throws IOStreamError.InputStreamError {
			int ret = 0;
			if((ret = impl.read(buf)) == 0) {
				throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
			}
			if(ret == -1) {
				throw new IOStreamError.InputStreamError.END_OF_DATA("Platform error");
			}
			return ret;
		}
	}
	class NetOutputStream :	OutputStream {
		NetStreamPlatformImpl impl;
		protected NetOutputStream(NetStreamPlatformImpl myPlat) {
			impl = myPlat;
		}
		public override int write(extring*buf) throws IOStreamError.OutputStreamError {
			return impl.write(buf);
		}
	}
	NetStreamPlatformImpl plat;
	NetInputStream nis;
	NetOutputStream nos;
	public NetStreamImpl() {
		base();
		plat = NetStreamPlatformImpl();
		nis = new NetInputStream(plat);
		nos = new NetOutputStream(plat);
	}
	public override void connect(extring*path, aroop_uword8 flags) throws IOStreamError.NetStreamError {
		plat.connect(path, flags);
	}
	public override InputStream getInputStream() throws IOStreamError.NetStreamError {
		return nis;
	}
	public override OutputStream getOutputStream() throws IOStreamError.NetStreamError {
		return nos;
	}
	public override int close() {
		return plat.close();
	}
}
/** @}*/
