using aroop;
using shotodol;

/** \addtogroup test
 *  @{
 */
internal class shotodol.UnitTestCommand : shotodol.M100Command {
	etxt prfx;
	public UnitTestCommand() {
		prfx = etxt.from_static("unittest");
		base();
	}

	~UnitTestCommand() {
	}

	public override etxt*get_prefix() {
		return &prfx;
	}
	public override int act_on(etxt*cmdstr, OutputStream pad, M100CommandSet cmds) {
		txt unittest = new txt.from_static("unittest");
		Extension?root = Plugin.get(unittest);
		while(root != null) {
			UnitTest?test = (UnitTest)root.getInstance(null);
			if(test != null)
				test.test();
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
}
/** @}*/
