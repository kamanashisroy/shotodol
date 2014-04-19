using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public errordomain IOStreamError.InputStreamError {
	NOT_SUPPORTED,
	END_OF_DATA,
	INPUT_STREAM_FAILED,
}

public abstract class shotodol.InputStream : Replicable {
	public virtual int available_bytes() throws IOStreamError.InputStreamError {
		throw new IOStreamError.InputStreamError.NOT_SUPPORTED("available_bytes() is not supported");
	}
	public abstract int read(etxt*buf) throws IOStreamError.InputStreamError;
	public virtual bool rewind() throws IOStreamError.InputStreamError {
		throw new IOStreamError.InputStreamError.NOT_SUPPORTED("rewind() is not supported");
	}
	public virtual void close() throws IOStreamError.InputStreamError {
		return;
	}
}
/** @}*/
