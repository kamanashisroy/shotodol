using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public abstract class shotodol.ActivePipeOutputStream : PipeOutputStream {
	public ActivePipeOutputStream(InputStream givenSource) {
		base(givenSource);
	}
	~ActivePipeOutputStream() {
	}
	public int step() throws IOStreamError.OutputStreamError {
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
}


/* @} */
