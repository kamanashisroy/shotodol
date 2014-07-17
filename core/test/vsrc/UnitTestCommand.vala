using aroop;
using shotodol;

/** \addtogroup test
 *  @{
 */
internal class shotodol.UnitTestCommand : shotodol.M100Command {
	public UnitTestCommand() {
		estr prefix = estr.set_static_string("unittest");
		base(&prefix);
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) {
		estr unittest = estr.set_static_string("unittest");
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
