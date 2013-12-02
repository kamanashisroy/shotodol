using aroop;
using shotodol;

public errordomain IOStreamError.FileOutputStreamError {
	COULD_NOT_OPEN_FILE_FOR_WRITING,
}

public class shotodol.FileOutputStream : OutputStream {
	shotodol_platform.LinuxFileStream?fp;
	bool closed;
	
	public FileOutputStream.from_file(etxt*filename) throws IOStreamError.FileOutputStreamError {
		closed = true;
		fp = shotodol_platform.LinuxFileStream.open(filename.to_string(), "w");
		if(fp == null) {
			throw new IOStreamError.FileOutputStreamError.COULD_NOT_OPEN_FILE_FOR_WRITING("Could not open file");
		}
		closed = false;
	}

	~FileOutputStream() {
		close();
	}

	public override int write(etxt*buf) throws IOStreamError.OutputStreamError {
		return fp.write(buf);
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(!closed) {
			fp.close();
			closed = true;
		}
	}
}
