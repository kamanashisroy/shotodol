using aroop;
using shotodol;

public class shotodol.CommandServer: Module {

	Set<shotodol.Command> cmds;
	int register(Command cmd) {
		cmds.add(cmd)	
		return 0;
	}
	int unregister(Command cmd) {
		// TODO fill me
		return 0;
	}
}
