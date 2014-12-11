using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */

public class shotodol.PipeStream : StreamDescriptor {
	protected shotodol_platform.fileio pipeFD[2];
	StandardOutputStream?pout;
	StandardInputStream?pin;
	protected int index;
	public PipeStream() {
	}
	public int build() {
		return shotodol_platform.fileio.pipe(pipeFD);
	}
	public override OutputStream getOutputStream() {
		if(pout == null) {
			pout = new StandardOutputStream();
			pout.fd = pipeFD[index];
		}
		return pout;
	}
	public override InputStream getInputStream() {
		if(pin == null) {
			pin = new StandardInputStream();
			pin.fd = pipeFD[index];
		}
		return pin;
	}
}
/* @} */
