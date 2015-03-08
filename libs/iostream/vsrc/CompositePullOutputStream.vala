using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public abstract class shotodol.CompositePullOutputStream : OutputStream {
	protected bool closed;
	OPPList<InputStream> sources;
	public CompositePullOutputStream(int inc = 16, uchar mark = aroop.factory_flags.HAS_LOCK | aroop.factory_flags.SWEEP_ON_UNREF) {
		closed = false;
		sources = OPPList<InputStream>(inc, mark);
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
		if(closed)
			return 0;
		sources.visit_each((x) => {
			unowned InputStream source = ((AroopPointer<InputStream>)x).getUnowned();
			int available = source.availableBytes();
			if(available <= 0)
				return 0;
#if SHOTODOL_FD_DEBUG
			print("There are %d bytes of data from worker threads\n", available);
#endif
			extring inp = extring();
			inp.rebuild_in_heap(available+4);
			try {
				source.read(&inp);
			} catch(IOStreamError.InputStreamError e) {
				extring sourceName = extring();
				source.to_extring(&sourceName);
				print("Error in input stream [%s] : %s\n", sourceName.to_string(), e.to_string());
			}
			if(!inp.is_empty()) {
#if SHOTODOL_FD_DEBUG
				print("Writing %d bytes of data\n", inp.length());
#endif
				try {
					write(&inp);
				} catch(IOStreamError.OutputStreamError e) {
					extring sourceName = extring();
					source.to_extring(&sourceName);
					print("Error in output stream [%s] : %s\n", name.to_string(), e.to_string());
				}
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
