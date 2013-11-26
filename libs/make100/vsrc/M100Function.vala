using aroop;

internal class M100Function: Replicable {
	txt name;
	txt upper;
	ArrayList<txt> cmds;
	public M100Function(etxt*nm, etxt*more) {
		name = new txt.memcopy_etxt(nm);
		upper = new txt.memcopy_etxt(more);
		cmds = ArrayList<txt>();
	}
	~M100Function() {
		cmds.destroy();
	}
	public int addCommand(etxt*cmd) {
		txt newcmd = new txt.memcopy_etxt(cmd);
		cmds[cmds.count_unsafe()] = newcmd;
		return 0;
	}
	public txt getCommand(int index) {
		return cmds.get(index);
	}
}
