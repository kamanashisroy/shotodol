using aroop;
using shotodol;

/** \addtogroup test
 *  @{
 */
internal class shotodol.UnitTestCommand : shotodol.M100Command {
	public UnitTestCommand() {
		extring prefix = extring.set_static_string("unittest");
		base(&prefix);
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) {
		extring unittest = extring.set_static_string("unittest");
		Extension?root = Plugin.get(&unittest);
		while(root != null) {
			UnitTest?test = (UnitTest)root.getInterface(null);
			if(test != null)
				test.test();
			Extension?next = root.getNext();
			root = next;
		}
		return 0;
	}
}
/** @}*/
