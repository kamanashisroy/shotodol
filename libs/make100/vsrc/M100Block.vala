using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal class M100Block: Searchable {
	txt name;
	txt upper;
	ArrayList<txt> cmds;
	ArrayList<M100Block> blocks;
	int ccount;
	int fnlineno;
	internal void build(etxt*nm, etxt*proto, int lineno) {
		name = new txt.memcopy_etxt(nm);
		upper = new txt.memcopy_etxt(proto);
		fnlineno = lineno;
		ccount = 0;
		cmds = ArrayList<txt>();
		blocks = ArrayList<M100Block>();
		set_hash(name.get_hash());
		etxt varname = etxt.from_static("function");
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
	
	internal int addCommand(etxt*cmd, int lineno) {
		txt newcmd = new txt.memcopy_etxt(cmd);
		M100Parser.trim(newcmd);
		cmds[ccount++] = newcmd;
		etxt varname = etxt.from_static("function_command");
		Watchdog.watchvar(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&varname,newcmd);
		return 0;
	}
	internal txt? getCommandAt(int index) {
		return cmds[index];
	}
}
/** @}*/
