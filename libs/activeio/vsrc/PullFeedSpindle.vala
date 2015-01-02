using aroop;
using shotodol;

/** \addtogroup activeio
 *  @{
 */
public class shotodol.activeio.PullFeedFiber : Fiber {
	PullFeedStream?pfs;
	public class PullFeedFiber(InputStream?source, OutputStream?down) {
		pfs = new PullFeedStream(source, down);
	}
	public void feed(OutputStream down) {
		pfs.feed(down);
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
		return 0;
	}
}
/* @} */
