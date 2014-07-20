using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal class M100Block: Searchable {
	xtring name;
	xtring upper;
	ArrayList<xtring> cmds;
	ArrayList<M100Block> blocks;
	int ccount;
	int fnlineno;
	internal void build(extring*nm, extring*proto, int lineno) {
		name = new xtring.copy_on_demand(nm);
		upper = new xtring.copy_on_demand(proto);
		fnlineno = lineno;
		ccount = 0;
		cmds = ArrayList<xtring>();
		blocks = ArrayList<M100Block>();
		set_hash(name.fly().getStringHash());
		extring varname = extring.set_static_string("function");
		Watchdog.watchvar(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&varname,name);
	}
	~M100Block() {
		blocks.destroy();
		cmds.destroy();
	}

	internal int addBlock(M100Block bl, int lineno) {
		blocks[lineno] = bl;
		return 0;
	}

	internal M100Block? getBlockAt(int lineno) {
		return blocks[lineno];
	}
	
	internal int addCommand(extring*cmd, int lineno) {
		xtring newcmd = new xtring.copy_on_demand(cmd);
		M100Parser.trim(newcmd);
		cmds[ccount++] = newcmd;
		extring varname = extring.set_static_string("function_command");
		Watchdog.watchvar(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&varname,newcmd);
		return 0;
	}
	internal xtring? getCommandAt(int index) {
		return cmds[index];
	}
}
/** @}*/
