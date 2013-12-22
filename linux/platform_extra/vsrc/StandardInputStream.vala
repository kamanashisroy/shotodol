using aroop;
using shotodol;

public class shotodol.StandardInputStream : InputStream {
	shotodol_platform.fileio?fd;
	
	public StandardInputStream() {
		fd = shotodol_platform.fileio.stdin();
	}

	~StandardInputStream() {
	}

	public override int read(etxt*buf) throws IOStreamError.InputStreamError {
		if(fd.read(buf) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		}
		return 0;
	}
	
	public int readLine(etxt*buf) throws IOStreamError.InputStreamError {
		if(fd.readLine(buf) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		}
		return 0;
	}
}
