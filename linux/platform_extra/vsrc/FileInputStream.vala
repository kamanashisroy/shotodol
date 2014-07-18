using aroop;
using shotodol;

/**
 * \ingroup platform
 * \defgroup linux_extra Linux extra
 */

/** \addtogroup linux_extra
 *  @{
 */

public errordomain IOStreamError.FileInputStreamError {
	COULD_NOT_OPEN_FILE,
}

public class shotodol.FileInputStream : InputStream {
	shotodol_platform.PlatformFileStream?fp;
	bool closed;
	
	public FileInputStream.from_file(extring*filename) throws IOStreamError.FileInputStreamError {
		closed = true;
		fp = shotodol_platform.PlatformFileStream.open(filename.to_string(), "r");
		if(fp == null) {
			throw new IOStreamError.FileInputStreamError.COULD_NOT_OPEN_FILE("Could not open file");
		}
		closed = false;
	}

	~FileInputStream() {
		close();
	}

	public override int read(extring*buf) throws IOStreamError.InputStreamError {
		int ret = 0;
		if((ret = fp.read(buf)) == 0) {
			throw new IOStreamError.InputStreamError.END_OF_DATA("File end");
		}
		return ret;
	}

	public override void close() throws IOStreamError.InputStreamError {
		if(!closed) {
			fp.close();
			closed = true;
		}
	}
}
/* @} */
