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
public class shotodol.activeio.CompositePullSingleFeedFiber : Fiber {
	CompositePullSingleFeedStream?pfs;
	public class CompositePullSingleFeedFiber() {
		pfs = new CompositePullSingleFeedStream();
	}
	public void setName(extring*name) {
		pfs.setName(name);
	}
	public void feed(OutputStream down) {
		pfs.feed(down);
	}
	public void pull(InputStream source) {
		pfs.pull(source);
	}
	public override int start(Fiber?plr) {
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
		pfs.close();
		return 0;
	}
}
/* @} */
