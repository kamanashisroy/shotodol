using aroop;
using shotodol;

/** \addtogroup make100
 *  @{
 */
internal class M100VirtualMachineFrame: Replicable {
	int index;
	M100Block target;
	internal void build(M100Block func) {
		index = 0;
		target = func;
	}
	public txt nextCommand() {
		return target.getCommandAt(index++);
	}
	public M100Block?getBlockAt(int lineno) {
		return target.getBlockAt(lineno);
	}
}
/** @}*/
