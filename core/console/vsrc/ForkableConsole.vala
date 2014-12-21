using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */
internal abstract class ForkableConsole : ConsoleSpindle {
	ArrayList<ForkStream> children;
	ForkStream?x;
	uint pipeCount;
	internal bool isParent;
	public ForkableConsole() {
		base();
		pipeCount = 0;
		children = ArrayList<ForkStream>();
		isParent = true;
	}
	~ForkableConsole() {
	}
	
	internal int onFork_Before(extring*msg, extring*output) {
		x = new ForkStream();
		if(x.onFork_Before() != 0) {
			return -1;
		}
		uint i = pipeCount;
		pipeCount++;
		children.set(i,x);
		return 0;
	}
	internal int onFork_After_Parent(extring*msg, extring*output) {
		if(x == null)
			return -1;
		x.onFork_After(false);
#if SHOTODOL_FORK_DEBUG
		x.dump();
#endif
		print("Parent process is up\n");
		x = null;
		return 0;
	}
	internal int onFork_After_Child(extring*msg, extring*output) {
		if(x == null)
			return -1;
		isParent = false;
		x.onFork_After(true);
		pull(x.getInputStream());
#if SHOTODOL_FORK_DEBUG
		x.dump();
#endif
		print("Child process is up\n");
		return 0;
	}
	internal OutputStream?getChildOutputStream(int i) {
		ForkStream?child = children[i];
		if(child == null)
			return null;
		return child.getOutputStream();
	}
	internal uint getChildCount() {
		return pipeCount;
	}
}


/* @} */
