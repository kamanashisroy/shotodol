using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100CommandSet: Replicable {
	public HashTable<M100Variable?> vars;
	Set<M100Command> cmds;
	BrainEngine<M100Command> be;
	txt command;
	public M100CommandSet() {
		command = new txt.from_static("command");
		cmds = Set<M100Command>();
		be = new BrainEngine<M100Command>();
		vars = HashTable<M100Variable?>();
		register(new M100GotoCommand());
	}
	~M100CommandSet() {
		cmds.destroy();
		vars.destroy();
	}
	public int list(OutputStream pad) {		
		cmds.visit_each((data) =>{
			unowned M100Command cmd = ((container<M100Command>)data).get();
			cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
			//etxt*prefix = cmd.get_prefix();
			//if(prefix == null) return 0;
			//if(!prefix.equals(cmd_str)) return 0;
			//mycmd = cmd;
			return 0;
		}, Replica_flags.ALL, 0, Replica_flags.ALL, 0, 0, 0);
		return 0;
	}
	public int register(M100Command cmd) {
		etxt dlg = etxt.stack(128);
		dlg.printf("Registering %s command\n", cmd.get_prefix().to_string());
		Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),10,0,0,0,&dlg);
		cmds.add(cmd);
		be.memorize_etxt(cmd.get_prefix(), cmd);
		return 0;
	}
	public int unregister(M100Command cmd) {
		// TODO fill me
		return 0;
	}
	public M100Command? percept(etxt*cmd_str) {
		etxt inp = etxt.same_same(cmd_str);
		etxt cmdName = etxt.EMPTY();
		LineAlign.next_token(&inp, &cmdName); // second token
		Extension?root = Plugin.get(command);
		while(root != null) {
			M100Command x = (M100Command)root.getInstance(null);
			etxt*nm = x.get_prefix();
			if(cmdName.equals(nm)) return x;
			Extension?next = root.getNext();
			root = next;
		}
		return null;
		//return be.percept_prefix_match(cmd_str);//be.direction(cmd_str);
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
