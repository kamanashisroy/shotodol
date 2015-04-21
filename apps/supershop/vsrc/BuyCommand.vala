using aroop;
using shotodol;
using supershop;

/** \addtogroup supershop
 *  @{
 */

internal class shotodol.supershop.BuyCommand : M100Command {
	enum Options {
		PENCIL = 1,
		PAPER,
	}
	public BuyCommand() {
		extring prefix = extring.set_static_string("buy");
		base(&prefix);
		addOptionString("-pencil", M100Command.OptionType.NONE, Options.PENCIL, "buy pencil"); // add command parameter
		addOptionString("-paper", M100Command.OptionType.NONE, Options.PAPER, "buy paper"); // add command parameter
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed { // overrides act_on() method from M100Command
		Paper?paper = null;
		Pencil?pencil = null;
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}

		if(vals[Options.PENCIL] != null) {
			extring pencilPoint = extring.set_static_string("pencil");
			PluginManager.acceptVisitor(&pencilPoint, (x) => {
				pencil = (Pencil)x.getInterface(null);
			});
			extring bfr = extring.stack(512); // allocate memory in stack
			if(pencil == null) {
				throw new M100CommandError.ActionFailed.OTHER("No pencil found");
			}
			pencil.getDescription(&bfr);
			pad.write(&bfr);
			return 0;
		}
		if(vals[Options.PAPER] != null) {
			extring paperPoint = extring.set_static_string("paper");
			PluginManager.acceptVisitor(&paperPoint, (x) => {
				paper = (Paper)x.getInterface(null);
			});
			extring bfr = extring.stack(512); // allocate memory in stack
			if(paper == null) {
				throw new M100CommandError.ActionFailed.OTHER("No paper found");
			}
			paper.getDescription(&bfr);
			pad.write(&bfr);
			return 0;
		}

		return 0;
	}

	public override int desc(M100Command.CommandDescType tp, OutputStream pad) { // This describes the application of the command to the user
		switch(tp) {
			case M100Command.CommandDescType.COMMAND_DESC_FULL:
			extring x = extring.stack(512); // allocate memory in stack
			x.concat_string("\tBuy command buys pencil or paper and prints their description.\n");
			x.concat_string("EXAMPLE:\n");
			x.concat_string("\t`buy -pencil` buys a pencil if available.\n");
			pad.write(&x);
			break;
		}
		return base.desc(tp, pad);
	}
}
/* @} */
