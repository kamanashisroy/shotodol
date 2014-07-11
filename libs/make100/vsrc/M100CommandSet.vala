using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100CommandSet: Replicable {
	public HashTable<M100Variable?> vars;
	BrainEngine<M100Command>?be;
	txt command;
	M100GotoCommand gcmd;
	public M100CommandSet() {
		command = new txt.from_static("command");
		//cmds = Set<M100Command>();
		be = new BrainEngine<M100Command>();
		vars = HashTable<M100Variable?>();
		gcmd = new M100GotoCommand();
		be.memorize_etxt(gcmd.get_prefix(), gcmd);
	}
	~M100CommandSet() {
		vars.destroy();
	}
	public int list(OutputStream pad) {		
		Extension?root = Plugin.get(command);
		while(root != null) {
			M100Command?cmd = (M100Command)root.getInstance(null);
			if(cmd != null)
				cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
	public int rehash() {
		be = new BrainEngine<M100Command>();
		be.memorize_etxt(gcmd.get_prefix(), gcmd);
		Extension?root = Plugin.get(command);
		while(root != null) {
			M100Command?cmd = (M100Command)root.getInstance(null);
			if(cmd != null)
				be.memorize_etxt(cmd.get_prefix(), cmd);
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
	public M100Command? percept(etxt*cmd_str) {
		return be.percept_prefix_match(cmd_str);//be.direction(cmd_str);
	}
	public int act_on(etxt*cmd_str, OutputStream pad, M100Script?sc) {
		if(cmd_str.char_at(0) == '#') { // skip the comments
			return 0;
		}
		etxt target = etxt.EMPTY();
		txt rcmd = M100Command.rewrite(cmd_str, &vars);
		M100Command? mycmd = percept(rcmd);
		//io.say_static("acting ..\n");
		if(mycmd == null) {
			// show menu ..
			etxt dlg = etxt.from_static("Command not found. Please try one of the following..\n");
			pad.write(&dlg);
			list(pad);
			return -1;
		}
		int ret = 0;
		try {
			mycmd.greet(pad);
			ret = mycmd.act_on(rcmd, pad, this);
			mycmd.bye(pad, true);
		} catch(M100CommandError.ActionFailed e) {
			mycmd.bye(pad, false);
			return -1;
		}
		if(sc == null) return 0;
		if(ret >= M100Command.FlowControl.GOTO_LINENO) {
			sc.gotoLine(ret - M100Command.FlowControl.GOTO_LINENO);
		} else if(ret == M100Command.FlowControl.SKIP_BLOCK) {
			sc.step(); // skip the step
		}
		return 0;
	}
}
/* @} */
