using aroop;
using shotodol;

/** \addtogroup iostream
 *  @{
 */
public class shotodol.PullFeedStream : PullOutputStream {
	OutputStream?sink;
	public PullFeedStream(InputStream?x, OutputStream?given) {
		base(x);
		sink = given;
	}
	public void feed(OutputStream?given) {
		sink = given;
	}
	public override int write(extring*content) throws IOStreamError.OutputStreamError {
		if(sink == null)
			return content.length(); // should we shift the length data ??
		return sink.write(content);
	}
}
/* @} */
