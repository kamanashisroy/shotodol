using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */
internal abstract class ForkableConsole : ConsoleFiber {
	ConsoleSlaveNode node;
	public ForkableConsole() {
		base();
		node = ConsoleSlaveNode();
	}
	~ForkableConsole() {
	}
	
	internal int onFork_Before(extring*msg, extring*output) {
		return node.master.onFork_Before(msg, output);
	}
	internal int onFork_After_Parent(extring*msg, extring*output) {
		return node.master.onFork_After_Parent(msg, output);
	}
	internal int onFork_After_Child(extring*msg, extring*output) {
		if(node.onFork_After_Child(msg, output) == 0) {
			pull(node.cis);
		}
		return 0;
	}
	internal OutputStream?getChildOutputStream(int i) {
		return node.master.getChildOutputStream(i);
	}
	internal uint getChildCount() {
		return node.master.getChildCount();
	}
	internal bool isParent() {
		return node.master.node.isParent;
	}
	internal int onQuitHook(extring*msg, extring*output) {
		return node.master.onQuitHook(msg, output);
	}
	internal int statusHook(extring*msg, extring*output) {
		extring stat = extring.stack(128);
		stat.printf("Console:%d(%s)\n", (int)node.master.node.index, node.master.node.isParent?"parent":"child");
		output.concat(&stat);
		return 0;
	}
}


/* @} */
