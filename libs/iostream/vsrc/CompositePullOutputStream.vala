using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public abstract class shotodol.CompositePullOutputStream : OutputStream {
	protected bool closed;
	Set<InputStream> sources;
	public CompositePullOutputStream(int inc = 16, uchar mark = aroop.factory_flags.HAS_LOCK | aroop.factory_flags.SWEEP_ON_UNREF) {
		closed = false;
		sources = Set<InputStream>(inc, mark);
	}
	~CompositePullOutputStream() {
		sources.destroy();
	}

	public void pull(InputStream?given) {
		if(closed)
			return;
		sources.add(given);
	}

	public int step() throws IOStreamError.OutputStreamError {
		sources.visit_each((x) => {
			InputStream source = (InputStream)x;
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
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}

	public override void close() throws IOStreamError.OutputStreamError {
		if(closed)
			return;
		closed = true;
		sources.destroy(); // XXX should we close each of them ??
	}
}


/* @} */
