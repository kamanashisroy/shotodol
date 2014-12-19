using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */

public class shotodol.PipeStream : StreamDescriptor {
	protected shotodol_platform.fileio pipeFD[2];
	StandardOutputStream?pout;
	StandardInputStream?pin;
	public PipeStream() {
		pout = null;
		pin = null;
	}
	public int build() {
		return shotodol_platform.fileio.pipe(pipeFD);
	}
	public override OutputStream getOutputStream() {
		if(pout == null) {
			pout = new StandardOutputStream.fromFD(pipeFD[1]);
		}
		return pout;
	}
	public override InputStream getInputStream() {
		if(pin == null) {
			pin = new StandardInputStream.fromFD(pipeFD[0]);
		}
		return pin;
	}
#if SHOTODOL_FORK_DEBUG
	public void dump() {
		print("pipe 0:%d and pipe 1:%d\n", pipeFD[0], pipeFD[1]);
	}
#endif
}
/* @} */
