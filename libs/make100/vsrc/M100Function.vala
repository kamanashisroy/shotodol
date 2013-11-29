using aroop;
using shotodol;

internal class M100Function: Replicable {
	txt name;
	txt upper;
	ArrayList<txt> cmds;
	public M100Function(etxt*nm, etxt*more) {
		name = new txt.memcopy_etxt(nm);
		upper = new txt.memcopy_etxt(more);
		cmds = ArrayList<txt>();
		etxt varname = etxt.from_static("function");
		Watchdog.watchvar(5,0,0,0,&varname,nm);
	}
	~M100Function() {
		cmds.destroy();
	}
	public int addCommand(etxt*cmd) {
		txt newcmd = new txt.memcopy_etxt(cmd);
		M100Parser.trim(newcmd);
		cmds[cmds.count_unsafe()] = newcmd;
		etxt varname = etxt.from_static("function_command");
		Watchdog.watchvar(5,0,0,0,&varname,newcmd);
		return 0;
	}
	public txt getCommand(int index) {
		return cmds.get(index);
	}
}
