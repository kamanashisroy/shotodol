using aroop;
using shotodol;

/** \addtogroup fork
 *  @{
 */
internal class shotodol.fork.ForkCommand : shotodol.M100Command {
	public ForkCommand() {
		extring prefix = extring.set_static_string("fork");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		forkHook(null, null);
		return 0;
	}

	internal int forkHook(extring*msg, extring*output) {
		extring forkEntry = extring.set_static_string("onFork/before");
		Plugin.swarm(&forkEntry, msg, output); // before fork
		int pid = shotodol_platform.ProcessControl.fork();
		if(pid < 0) { // fork error
			forkEntry.rebuild_and_set_static_string("onFork/error");
		} else if(pid == 0) { // child process
			forkEntry.rebuild_and_set_static_string("onFork/after/child");
		} else { // parent process
			forkEntry.rebuild_and_set_static_string("onFork/after/parent");
		}
		Plugin.swarm(&forkEntry, msg, output); // after fork
		return 0;
	}
}
/* @} */
