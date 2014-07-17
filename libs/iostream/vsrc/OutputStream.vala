using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public errordomain IOStreamError.OutputStreamError {
	OUTPUT_STREAM_FAILED,
}

public abstract class shotodol.OutputStream : Replicable {
	public abstract int write(estr*buf) throws IOStreamError.OutputStreamError;
	public virtual void close() throws IOStreamError.OutputStreamError {
		return;
	}
}
/** @}*/
