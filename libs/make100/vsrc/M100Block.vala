using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal class M100Block: Searchable {
	str name;
	str upper;
	ArrayList<str> cmds;
	ArrayList<M100Block> blocks;
	int ccount;
	int fnlineno;
	internal void build(estr*nm, estr*proto, int lineno) {
		name = new str.copy_on_demand(nm);
		upper = new str.copy_on_demand(proto);
		fnlineno = lineno;
		ccount = 0;
		cmds = ArrayList<str>();
		blocks = ArrayList<M100Block>();
		set_hash(name.ecast().getStringHash());
		estr varname = estr.set_static_string("function");
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
	
	internal int addCommand(estr*cmd, int lineno) {
		str newcmd = new str.copy_on_demand(cmd);
		M100Parser.trim(newcmd);
		cmds[ccount++] = newcmd;
		estr varname = estr.set_static_string("function_command");
		Watchdog.watchvar(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&varname,newcmd);
		return 0;
	}
	internal str? getCommandAt(int index) {
		return cmds[index];
	}
}
/** @}*/
