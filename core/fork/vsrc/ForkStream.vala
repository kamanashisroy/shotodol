using aroop;
using shotodol;

/** \addtogroup fork
 *  @{
 */
public class shotodol.fork.ForkStream : PipeStream {
	public ForkStream() {
		base();
	}
	public int onFork_Before() {
		return build();
	}
	public int onFork_After(bool child = false) {
		if(child) {
			index = 1;
		}
		return 0;
	}
}
/* @} */
