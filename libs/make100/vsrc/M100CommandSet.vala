using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
public class shotodol.M100CommandSet: Replicable {
	public HashTable<xtring,M100Variable?> vars;
	Context<M100Command>?be;
	extring command;
	M100GotoCommand gcmd;
	public bool quiet = false;
	public M100CommandSet() {
		command = extring.set_static_string("command");
		//cmds = Set<M100Command>();
		be = new Context<M100Command>();
		vars = HashTable<xtring,M100Variable?>(xtring.hCb,xtring.eCb);
		gcmd = new M100GotoCommand();
		extring prfx = extring();
		gcmd.getPrefixAs(&prfx);
		be.assign_estr(&prfx, gcmd);
		quiet = false;
	}
	~M100CommandSet() {
		vars.destroy();
	}

	public int listCommands(OutputStream pad, extring*delim = null) {		
		PluginManager.acceptVisitor(&command, (x) => {
			M100Command?cmd = (M100Command)x.getInterface(null);
			if(cmd != null) {
				cmd.desc(M100Command.CommandDescType.COMMAND_DESC_TITLE, pad);
				if(delim != null)
					pad.write(delim.to_string());
			}
		});
		return 0;
	}

	public int rehash(extring*namesp) {
		if(!command.equals(namesp))
			command.rebuild_and_copy_on_demand(namesp);
		be = null; // we do not keep any reference to older interfaces after this point.
		be = new Context<M100Command>();
		extring gprfx = extring();
		gcmd.getPrefixAs(&gprfx);
		be.assign_estr(&gprfx, gcmd);
		PluginManager.acceptVisitor(namesp, (x) => {
			M100Command?cmd = (M100Command)x.getInterface(null);
			if(cmd != null) {
				extring prfx = extring();
				cmd.getPrefixAs(&prfx);
				be.assign_estr(&prfx, cmd);
			}
		});
		extring command_programming = extring.set_static_string("command/programming");
		PluginManager.acceptVisitor(&command_programming, (x) => {
			M100Command?cmd = (M100Command)x.getInterface(null);
			if(cmd != null) {
				extring prfx = extring();
				cmd.getPrefixAs(&prfx);
				be.assign_estr(&prfx, cmd);
			}
		});
		return 0;
	}

	public M100Command? lookup(extring*cmd_str) {
		return be.lookup_by_prefix(cmd_str);//be.direction(cmd_str);
	}
	public int act_on(extring*cmd_str, OutputStream pad, M100Script?sc) {
		if(cmd_str.char_at(0) == '#') { // skip the comments
			return 0;
		}
		extring target = extring();
		xtring rcmd = M100Command.rewrite(cmd_str, &vars);
		M100Command? mycmd = lookup(rcmd);
		//io.say_static("acting ..\n");
		if(mycmd == null) {
			// show menu ..
			extring dlg = extring.set_static_string("Command not found. Please try one of the following..\n");
			pad.write(&dlg);
			//extring delim = extring.set_static_string(" ");
			listCommands(pad);
			return -1;
		}
		int ret = 0;
		try {
			if(!quiet)mycmd.greet(pad);
			ret = mycmd.act_on(rcmd, pad, this);
			if(!quiet)mycmd.bye(pad, true);
		} catch(M100CommandError.ActionFailed e) {
			extring dlg = extring.stack(128);
			dlg.concat_string("Failed:\t");
			dlg.concat_string(e.to_string());
			dlg.concat_char('\n');
			pad.write(&dlg);
			if(!quiet) {
				mycmd.bye(pad, false);
			}
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
