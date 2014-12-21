using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public abstract class shotodol.PullOutputStream : OutputStream {
	protected bool closed;
	protected InputStream?source;
	public PullOutputStream(InputStream?givenSource) {
		closed = false;
		source = givenSource;
	}
	~PullOutputStream() {
	}

	public void pull(InputStream?given) {
		source = given;
	}

	public int step() throws IOStreamError.OutputStreamError {
		if(source == null)
			return 0;
		int available = source.availableBytes();
		if(available <= 0)
			return 0;
		extring inp = extring();
		inp.rebuild_in_heap(available+4);
		source.read(&inp);
		if(!inp.is_empty()) {
			write(&inp);
		}
		inp.destroy();
		return 0;
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(closed)
			return;
		closed = true;
		if(source != null)
			source.close();
	}
}


/* @} */
