using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public errordomain IOStreamError.OutputStreamError {
	OUTPUT_STREAM_FAILED,
}

public abstract class shotodol.OutputStream : Replicable {
	protected extring name;
	public void setName(extring*givenName) {
		name.rebuild_and_copy_on_demand(givenName);
	}
	public void to_extring(extring*outArg) {
		outArg.rebuild_and_copy_on_demand(&name);
	}
	public abstract int write(extring*buf) throws IOStreamError.OutputStreamError;
	public virtual void close() throws IOStreamError.OutputStreamError {
		return;
	}
}
/** @}*/
