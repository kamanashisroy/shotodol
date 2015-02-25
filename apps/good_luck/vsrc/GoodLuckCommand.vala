using aroop;
using shotodol;

/** \addtogroup good_luck
 *  @{
 */

internal class shotodol.GoodLuckCommand : M100Command {
	enum Options {
		NAME = 1,
	}
	public GoodLuckCommand() {
		extring prefix = extring.set_static_string("goodluck");
		base(&prefix);
		addOptionString("-name", M100Command.OptionType.TXT, Options.NAME, "Your name"); // add command parameter
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed { // overrides act_on() method from M100Command
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		extring response = extring();
		response.rebuild_in_heap(512);

		// calling the "goodluck/before" hook
		extring entry = extring.set_static_string("goodluck/before"); // declare embedded Xtring that refer to "goodluck/before".
		PluginManager.swarm(&entry, null, &response); // call all the "goodluck/before" hooks
		pad.write(&response); // print out the response of the "goodluck/before" hook


		// showing good luck 
		extring bfr = extring.stack(128); // take a buffer
		bfr.concat_string("Good luck "); 
		if(vals[Options.NAME] != null) {
			bfr.concat(vals[Options.NAME]);
		}
		bfr.concat_char('\n');
		bfr.concat_string("Have nice time with shotodol.\n");
		pad.write(&bfr);


		response.truncate(); // cleanup
		// calling the "goodluck/after" hook
		entry.rebuild_and_set_static_string("goodluck/after"); // refer to "goodluck/after".
		PluginManager.swarm(&entry, vals[Options.NAME], &response); // call all the "goodluck/after" hooks
		pad.write(&response); // print out the response of the "goodluck/after" hook
		return 0;
	}

	public override int desc(M100Command.CommandDescType tp, OutputStream pad) { // This describes the application of the command to the user
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_FULL:
			extring x = extring.stack(512); // allocate memory in stack
			x.concat_string("\tGoodluck command greets someone by his name.\n");
			x.concat_string("EXAMPLE:\n");
			x.concat_string("\t`goodluck -name Bob` wishes good luck to Bob.\n");
			pad.write(&x);
			break;
		}
		return base.desc(tp, pad);
	}
}
/* @} */
