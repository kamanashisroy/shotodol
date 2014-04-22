using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */
public class shotodol.StandardInputStream : InputStream {
	shotodol_platform.fileio?fd;
	
	public StandardInputStream() {
		fd = shotodol_platform.fileio.stdin();
	}

	~StandardInputStream() {
	}

	public override int available_bytes() throws IOStreamError.InputStreamError {
		return fd.available_bytes();
	}

	public override int readChar(etxt*buf, bool dry) throws IOStreamError.InputStreamError {
		uchar ch = fd.getChar();
		if(ch != fd.EOF) {
			buf.concat_char(ch);
			if(dry) {
				fd.unGetChar(ch);
			}
		}
		return 0;
	}

	public override int read(etxt*buf) throws IOStreamError.InputStreamError {
		int bytes = 0;
		if((bytes = fd.read(buf)) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		} else if(bytes < 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("Fillme .. Some error");
		}
		return bytes;
	}
	
	public int readLine(etxt*buf) throws IOStreamError.InputStreamError {
		if(fd.readLine(buf) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		}
		return 0;
	}
}
/* @} */
