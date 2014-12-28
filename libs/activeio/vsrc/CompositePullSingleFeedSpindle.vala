using aroop;
using shotodol;

/**
 * \ingroup iostream
 * \defgroup activeio Active pulling and feeding streams
 * [Cohesion : Logical]
 */

/** \addtogroup activeio
 *  @{
 */
public class shotodol.activeio.CompositePullSingleFeedSpindle : Spindle {
	CompositePullSingleFeedStream?pfs;
	public class CompositePullSingleFeedSpindle() {
		pfs = new CompositePullSingleFeedStream();
	}
	public void feed(OutputStream down) {
		pfs.feed(down);
	}
	public void pull(InputStream source) {
		pfs.pull(source);
	}
	public override int start(Spindle?plr) {
		//print("Started console stepping ..\n");
		
		return 0;
	}

	public override int step() {
		try {
			pfs.step();
		} catch (IOStreamError.OutputStreamError e) {
			print("Error in standard input\n");
			return 0;
		}
		return 0;
	}

	public override int cancel() {
		return 0;
	}
}
/* @} */
