using aroop;
using shotodol;

/**
 * \defgroup core Core Modules
 */
/**
 * \ingroup core
 * \defgroup base Module Loader(base)
 */
/** \addtogroup base
 *  @{
 */
public abstract class shotodol.ModulePlugin : Module {
	public override int init() {
		owner = null;
		return 0;
	}
	public override int deinit() {
		owner.unload();
		return 0;
	}
	unowned shotodol_platform.plugin owner;
	public int initDynamic(shotodol_platform.plugin plg) {
		owner = plg;
		return 0;
	}
}
/* @} */
