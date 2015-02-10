using aroop;
using shotodol;

/** \addtogroup instant
 *  @{
 */

internal class shotodol.InstantCommand : M100Command {
	enum Options {
		LIST = 1,
	}
	public InstantCommand() {
		extring prefix = extring.set_static_string("instant");
		base(&prefix);
		addOptionString("-l", M100Command.OptionType.NONE, Options.LIST, "Display available instant modules");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		if(vals[Options.LIST] != null) {
			extring instpkg = extring.set_static_string(".instant");
			printList(&instpkg, pad);
		}
		return 0;
	}

	int printList(extring*infile, OutputStream pad) {
		FileInputStream fis = new FileInputStream.from_file(infile);
		LineInputStream lis = new LineInputStream(fis);
		do {
			extring instpkg = extring.stack(128);
			try {
				if(lis.read(&instpkg) == 0) {
					break;
				}
				pad.write(&instpkg);
			} catch(IOStreamError.InputStreamError e) {
			}
		}while(true);
		fis.close();
		lis.close();
		return 0;
	}
}
/* @} */
