using aroop;
using shotodol;

/** \addtogroup fork
 *  @{
 */
internal class shotodol.fork.ForkCommand : shotodol.M100Command {
	enum Options {
		TARGET = 1,
		CHILD_COUNT,
	}
	public ForkCommand() {
		extring prefix = extring.set_static_string("fork");
		base(&prefix);
		addOptionString("-t", M100Command.OptionType.TXT, Options.TARGET, "Target of the fork");
		addOptionString("-child", M100Command.OptionType.INT, Options.CHILD_COUNT, "Number of children to create");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		int childCount = 1;
		xtring? tmp = null;
		tmp = vals[Options.CHILD_COUNT];
		if(tmp != null) {
			childCount = tmp.fly().to_int();
			if(childCount <= 0 || childCount > 16) {
				throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid number of children asked.");
			}
		}
		xtring? arg = null;
		arg = vals[Options.TARGET];
		int i = 0;
		for(i = 0; i < childCount; i++) {
			if(forkHook(arg, null) == 0) {
				break;
			}
		}
		return 0;
	}

	internal int forkHook(extring*msg, extring*output) {
		extring forkEntry = extring.set_static_string("onFork/before");
		PluginManager.swarm(&forkEntry, msg, output); // before fork
		int pid = shotodol_platform.ProcessControl.fork();
		if(pid < 0) { // fork error
			forkEntry.rebuild_and_set_static_string("onFork/error");
		} else if(pid == 0) { // child process
			forkEntry.rebuild_and_set_static_string("onFork/after/child");
		} else { // parent process
			forkEntry.rebuild_and_set_static_string("onFork/after/parent");
		}
		PluginManager.swarm(&forkEntry, msg, output); // after fork
		forkEntry.rebuild_and_set_static_string("onFork/complete");
		PluginManager.swarm(&forkEntry, msg, output); // after fork
		return pid;
	}
}
/* @} */
