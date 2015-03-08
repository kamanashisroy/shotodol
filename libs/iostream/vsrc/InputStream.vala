using aroop;
using shotodol;

/**
 * \ingroup shotodol_library
 * \defgroup iostream Input Output Basic(iostream)
 * [Cohesion : Logical]
 */

/** \addtogroup iostream
 *  @{
 */
public errordomain IOStreamError.InputStreamError {
	NOT_SUPPORTED,
	END_OF_DATA,
	INPUT_STREAM_FAILED,
}

public abstract class shotodol.InputStream : Replicable {
	protected extring name;
	public void setName(extring*givenName) {
		name.rebuild_and_copy_on_demand(givenName);
	}
	public void to_extring(extring*outArg) {
		outArg.rebuild_and_copy_on_demand(&name);
	}
	public virtual int availableBytes() throws IOStreamError.InputStreamError {
		throw new IOStreamError.InputStreamError.NOT_SUPPORTED("available_bytes() is not supported");
	}
	public virtual int readChar(extring*buf, bool dry) throws IOStreamError.InputStreamError {
		throw new IOStreamError.InputStreamError.NOT_SUPPORTED("readChar() is not supported");
	}
	public abstract int read(extring*buf) throws IOStreamError.InputStreamError;
	public virtual bool rewind() throws IOStreamError.InputStreamError {
		throw new IOStreamError.InputStreamError.NOT_SUPPORTED("rewind() is not supported");
	}
	public virtual void close() throws IOStreamError.InputStreamError {
		return;
	}
}
/** @}*/
