using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */
public class shotodol.StandardOutputStream : OutputStream {
	internal shotodol_platform.fileio fd;
	public StandardOutputStream() {
		fd = shotodol_platform.fileio.stdout();
	}
	internal StandardOutputStream.fromFD(shotodol_platform.fileio gfd) {
		fd = gfd;
	}
	
#if SHOTODOL_FD_DEBUG
	public void dump() {
		print("Sandard output stream fd:%d\n", fd);
	}
#endif
	public override int write(extring*buf) throws IOStreamError.OutputStreamError {
		if(buf.is_zero_terminated()) {
			//print(buf.to_string_magical());
			fd.write(buf);
		} else {
			extring dlg = extring.stack_copy_deep(buf);
			dlg.zero_terminate();
			// print(dlg.to_string_magical());
			fd.write(&dlg);
		}
		return buf.length();
	}

	public override void close() throws IOStreamError.OutputStreamError {
		fd.close();
	}
}
/* @} */
