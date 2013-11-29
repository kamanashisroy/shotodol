using aroop;
using shotodol;

public errordomain IOStreamError.FileInputStreamError {
	COULD_NOT_OPEN_FILE,
}

public class shotodol.FileInputStream : InputStream {
	shotodol_platform.LinuxFileStream?fp;
	
	public FileInputStream.from_file(etxt*filename) throws IOStreamError.FileInputStreamError {
		fp = shotodol_platform.LinuxFileStream.open(filename.to_string(), "r");
		if(fp == null) {
			throw new IOStreamError.FileInputStreamError.COULD_NOT_OPEN_FILE("Could not open file");
		}
	}

	~FileInputStream() {
		close();
	}

	public override int read(etxt*buf) throws IOStreamError.InputStreamError {
		if(fp.read(buf) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		}
		return 0;
	}
	public int readLine(etxt*buf) throws IOStreamError.InputStreamError {
		return read(buf);
	}
	public override void close() throws IOStreamError.InputStreamError {
		if(fp != null)fp.close();
	}
}
