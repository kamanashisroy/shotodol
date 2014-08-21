using aroop;
using shotodol;

/** \addtogroup linux_extra
 *  @{
 */
public errordomain IOStreamError.FileOutputStreamError {
	COULD_NOT_OPEN_FILE_FOR_WRITING,
}

public class shotodol.FileOutputStream : OutputStream {
	shotodol_platform.PlatformFileStream?fp;
	
	public FileOutputStream.from_file(extring*filename) throws IOStreamError.FileOutputStreamError {
		fp = shotodol_platform.PlatformFileStream.open(filename.to_string(), "w");
		if(fp == null) {
			throw new IOStreamError.FileOutputStreamError.COULD_NOT_OPEN_FILE_FOR_WRITING("Could not open file");
		}
	}

	~FileOutputStream() {
		close();
	}

	public override int write(extring*buf) throws IOStreamError.OutputStreamError {
		return fp.write(buf);
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(fp != null) {
			fp = null;
		}
	}
}
/* @} */
