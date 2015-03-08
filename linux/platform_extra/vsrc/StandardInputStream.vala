using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */
public class shotodol.StandardInputStream : InputStream {
	internal shotodol_platform.fileio fd;
	
	public StandardInputStream() {
		fd = shotodol_platform.fileio.stdin();
	}
	internal StandardInputStream.fromFD(shotodol_platform.fileio gfd) {
		fd = gfd;
	}

	~StandardInputStream() {
	}

#if SHOTODOL_FD_DEBUG
	public void dump() {
		print("Sandard output stream fd:%d\n", fd);
	}
#endif
	public override int availableBytes() throws IOStreamError.InputStreamError {
		return fd.availableBytes();
	}

	public override int readChar(extring*buf, bool dry) throws IOStreamError.InputStreamError {
		uchar ch = fd.getChar();
		if(ch != fd.EOF) {
			buf.concat_char(ch);
			if(dry) {
				fd.unGetChar(ch);
			}
		}
		return 0;
	}

	public override int read(extring*buf) throws IOStreamError.InputStreamError {
		int bytes = 0;
		if((bytes = fd.read(buf)) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		} else if(bytes < 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA(fd.to_error_string());
		}
		return bytes;
	}
	
	public int readLine(extring*buf) throws IOStreamError.InputStreamError {
		if(fd.readLine(buf) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		}
		return 0;
	}
	public override void close() throws IOStreamError.InputStreamError {
		fd.close();
	}
}
/* @} */
