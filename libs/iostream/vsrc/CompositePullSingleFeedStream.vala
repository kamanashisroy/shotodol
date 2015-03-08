using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.CompositePullSingleFeedStream : CompositePullOutputStream {
	OutputStream?sink;
	public CompositePullSingleFeedStream(int inc = 16, uchar mark = aroop.factory_flags.HAS_LOCK | aroop.factory_flags.SWEEP_ON_UNREF, OutputStream?given = null) {
		base(inc, mark);
		sink = given;
	}
	public void feed(OutputStream?given) {
		sink = given;
	}
	public override int write(extring*content) throws IOStreamError.OutputStreamError {
		if(sink == null) {
			throw new IOStreamError.OutputStreamError.OUTPUT_STREAM_FAILED("No downstream to feed");
#if false
#if SHOTODOL_FD_DEBUG
			print("Nowhere to write !\n");
			return content.length(); // should we shift the length data ??
#endif
#endif
		}
#if SHOTODOL_FD_DEBUG
		print("Sinking data to browser\n");
#endif
		return sink.write(content);
	}
}
/* @} */
