using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup module Module
 * [Cohesion : Functional]
 */

/** \addtogroup module
 *  @{
 */
public abstract class shotodol.Module : Replicable {
	extring name;
	extring version;
	public bool isDynamic;
	public Module(extring*nm,extring*ver) {
		name = extring.copy_on_demand(nm);
		name.makeConstant();
		version = extring.copy_on_demand(ver);
		version.makeConstant();
		isDynamic = false;
	}
	~Module() {
		name.destroy();
		version.destroy();
	}
	public virtual void getNameAs(extring*nm) {
		nm.rebuild_and_copy_on_demand(&name);
	}
	public virtual void getVersionAs(extring ver) {
		ver.rebuild_and_copy_on_demand(&version);
	}
	public abstract int init();
	public abstract int deinit();
}
/** @}*/
