using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */

internal struct shotodol.ConsoleNode {
	public ForkStream?x; /* write down to child */
	public bool isParent;
	public uint index;
	public ConsoleNode() {
		x = null;
		isParent = true;
		index = 0;
	}

	internal int onFork_After_prepare_pipe() {
		/* Child Pipe is required */
		if(x == null)
			return -1;
		x.onFork_After(!isParent);
		return 0;
	}
	internal int cleanup_pipe() {
		x = null;
		return 0;
	}
}
