using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public abstract class shotodol.PipeOutputStream : OutputStream {
	protected bool closed;
	protected InputStream source;
	public PipeOutputStream(InputStream givenSource) {
		closed = false;
		source = givenSource;
	}
	~PipeOutputStream() {
	}

	public void connect(InputStream given) {
		source = given;
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(closed)return;
		closed = true;
		source.close();
	}
}


/* @} */
