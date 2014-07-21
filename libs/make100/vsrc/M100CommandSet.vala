using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100CommandSet: Replicable {
	public HashTable<xtring,M100Variable?> vars;
	BrainEngine<M100Command>?be;
	xtring command;
	M100GotoCommand gcmd;
	public M100CommandSet() {
		command = new xtring.copy_static_string("command");
		//cmds = Set<M100Command>();
		be = new BrainEngine<M100Command>();
		vars = HashTable<xtring,M100Variable?>(xtring.hCb,xtring.eCb);
		gcmd = new M100GotoCommand();
		extring prfx = extring();
		gcmd.getPrefixAs(&prfx);
		be.memorize_estr(&prfx, gcmd);
	}
	~M100CommandSet() {
		vars.destroy();
	}
	public int list(OutputStream pad) {		
		Extension?root = Plugin.get(command);
		while(root != null) {
			M100Command?cmd = (M100Command)root.getInterface(null);
			if(cmd != null)
				cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
	public int rehash() {
		be = null; // we do not keep any reference to older interfaces after this point.
		be = new BrainEngine<M100Command>();
		extring gprfx = extring();
		gcmd.getPrefixAs(&gprfx);
		be.memorize_estr(&gprfx, gcmd);
		Extension?root = Plugin.get(command);
		while(root != null) {
			M100Command?cmd = (M100Command)root.getInterface(null);
			if(cmd != null) {
				extring prfx = extring();
				cmd.getPrefixAs(&prfx);
				be.memorize_estr(&prfx, cmd);
			}
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
	public M100Command? percept(extring*cmd_str) {
		return be.percept_prefix_match(cmd_str);//be.direction(cmd_str);
	}
	public int act_on(extring*cmd_str, OutputStream pad, M100Script?sc) {
		if(cmd_str.char_at(0) == '#') { // skip the comments
			return 0;
		}
		extring target = extring();
		xtring rcmd = M100Command.rewrite(cmd_str, &vars);
		M100Command? mycmd = percept(rcmd);
		//io.say_static("acting ..\n");
		if(mycmd == null) {
			// show menu ..
			extring dlg = extring.set_static_string("Command not found. Please try one of the following..\n");
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
