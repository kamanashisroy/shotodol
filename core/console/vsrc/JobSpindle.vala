using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */
internal abstract class JobSpindle : ConsoleSpindle {
	ArrayList<ForkStream> children;
	uint forkIndex;
	uint pipeCount;
	public JobSpindle() {
		base();
		pipeCount = 0;
		children = ArrayList<ForkStream>();
	}
	~JobSpindle() {
	}
	
	internal int onFork_Before(extring*msg, extring*output) {
		ForkStream child = new ForkStream();
		if(child.onFork_Before() != 0) {
			return -1;
		}
		forkIndex = pipeCount;
		pipeCount++;
		children.set(forkIndex,child);
		return 0;
	}
	internal int onFork_After_Parent(extring*msg, extring*output) {
		ForkStream child = children[forkIndex];
		child.onFork_After(false);
		return 0;
	}
	internal int onFork_After_Child(extring*msg, extring*output) {
		ForkStream child = children[forkIndex];
		child.onFork_After(true);
		setInputStream(child.getInputStream());
		return 0;
	}
	internal OutputStream?getChildOutputStream(int x) {
		ForkStream?child = children[forkIndex];
		if(child == null)
			return null;
		return child.getOutputStream();
	}
	internal uint getChildCount() {
		return pipeCount;
	}
}


/* @} */
