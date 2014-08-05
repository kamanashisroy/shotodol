using aroop;
using shotodol;

/** \addtogroup test
 *  @{
 */
internal class shotodol.UnitTestCommand : shotodol.M100Command {
	enum Options {
		TARGET = 1,
		LIST,
	}
	public UnitTestCommand() {
		extring prefix = extring.set_static_string("unittest");
		base(&prefix);
		addOptionString("-t", M100Command.OptionType.TXT, Options.TARGET, "Test target(name)");
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "List all unit-test cases"); 
	}

	bool actHelper(UnitTest test, xtring?match, xtring?lst, OutputStream pad) {
		extring nm = extring();
		test.getNameAs(&nm);
		if(match != null && !nm.equals(match)) {
			return false;
		}
		extring dlg = extring.stack(128);
		dlg.concat(&nm);
		dlg.concat_char('\n');
		pad.write(&dlg);
		if(lst == null) {
			try {
				test.test();
			} catch(UnitTestError e) {
				dlg.printf("Test [%s] failed\n", nm.to_string());
				pad.write(&dlg);
				Watchdog.watchit(core.sourceFileName(), core.sourceLineNo(),1,Watchdog.WatchdogSeverity.ERROR,0,0,&dlg);
			}
		}
		return true;
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?lst = vals[Options.LIST];
		xtring?tgt = vals[Options.TARGET];
		extring unittest = extring.set_static_string("unittest");
		Extension?root = Plugin.get(&unittest);
		bool hit = false;
		
		while(root != null) {
			UnitTest?test = (UnitTest)root.getInterface(null);
			if(test != null) {
				bool ret = actHelper(test, tgt, lst, pad);
				hit = hit || ret;
			}
			Extension?next = root.getNext();
			root = next;
		}
		if(!hit && tgt != null) {
			extring dlg = extring.set_static_string("Target not found\n");
			pad.write(&dlg);
		}
		return 0;
	}
}
/** @}*/
