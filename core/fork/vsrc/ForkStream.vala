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
			pipeFD[1].close();
			index = 0;
		} else {
			pipeFD[0].close();
			index = 1;
		}
		return 0;
	}
}
/* @} */
