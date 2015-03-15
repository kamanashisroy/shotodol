using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */

internal struct shotodol.ConsoleMasterNode {
	public ConsoleNode node;
	ArrayList<ForkStream> children;
	uint pipeCount;
	ConsoleMasterNode() {
		node = ConsoleNode();
		children = ArrayList<ForkStream>();
		node.isParent = true;
		pipeCount = 0;
	}
	internal void cleanup() {
		node.cleanup_pipe();
		children.destroy();
	}
	internal int onFork_Before(extring*msg, extring*output) {
		node.x = new ForkStream();
		if(node.x.onFork_Before() != 0) {
			return -1;
		}
		node.index = pipeCount;
		pipeCount++;
		children.set(node.index,node.x);
		return 0;
	}
	internal OutputStream?getChildOutputStream(int i) {
		/* sanity check */
		if(i < 0 || i >= pipeCount)
			return null;
		ForkStream?child = children[i];
		if(child == null)
			return null;
		return child.getOutputStream();
	}
	internal uint getChildCount() {
		return pipeCount;
	}
	internal int onFork_After_Parent(extring*msg, extring*output) {
		if(!node.isParent)
			return 0;
		if(node.x == null) {
			print("EEEEEE! parent fork stream is null\n");
			return -1;
		}
		node.x.onFork_After(false);
#if SHOTODOL_FORK_DEBUG
		node.x.dump();
#endif
		print("Parent process is up\n");
		node.cleanup_pipe();
		return 0;
	}

	internal int onQuitHook(extring*msg, extring*output) {
		/* nothing to do if it is child node */
		if(!node.isParent) 
			return 0;
		int i = 0;
		for(; i < pipeCount; i++) {
			extring cmd = extring.set_static_string("quit\r\n\r\n");
			OutputStream?other = getChildOutputStream(i);
			if(other == null) continue;
			other.write(&cmd);
		}
		cleanup();
		return 0;
	}
}
