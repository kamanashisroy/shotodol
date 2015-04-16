using aroop;
using shotodol;
using shotodol.fork;

/** \addtogroup console
 *  @{
 */

internal struct shotodol.ConsoleSlaveNode {
	public ConsoleMasterNode master;
	public InputStream?cis;
	ConsoleSlaveNode() {
		master = ConsoleMasterNode();
		cis = null;
	}
	internal int onFork_After_Child(extring*msg, extring*output) {
		// TODO if msg contains noconsole then do not load console
		/*if(msg == null || !msg.equals(&master.node.consolekey)) {
			core.debug_print("-------- Child process is inactive as console slave\n");
			return 0;
		}*/
		master.node.isParent = false;
		if(master.node.x == null) {
			core.debug_print("EEEEEE! child fork stream is null\n");
			return -1;
		}

		// --------------------------------------------
		// Prepare pipes for communication ------------
		// --------------------------------------------
		if(master.node.onFork_After_prepare_pipe() != 0)
			return -1;
		// --------------------------------------------


		// Read from parent and feed incoming/sink ----
		master.node.x.onFork_After(true);
		cis = master.node.x.getInputStream();
		extring childName = extring.stack(128);
		childName.printf("Input from parent in child %d", (int)master.node.index);
		cis.setName(&childName);
#if SHOTODOL_FORK_DEBUG
		master.node.x.dump();
#endif
		
		// --------------------------------------------
		// Cleanup master 
		// --------------------------------------------
		master.cleanup();
		// --------------------------------------------

		core.debug_print("Child process is up\n");
		return 0;
	}

	internal void destroy() {
		cis.close();
		cis = null;
		master.cleanup();
	}
}
