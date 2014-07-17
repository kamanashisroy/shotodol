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
	estr name;
	estr version;
	public Module(estr*nm,estr*ver) {
		name = estr.copy_on_demand(nm);
		version = estr.copy_on_demand(ver);
	}
	~Module() {
		name.destroy();
		version.destroy();
	}
	public virtual void getNameAs(estr*nm) {
		nm.rebuild_and_copy_on_demand(&name);
	}
	public virtual void getVersionAs(estr ver) {
		ver.rebuild_and_copy_on_demand(&version);
	}
	public abstract int init();
	public abstract int deinit();
}
/** @}*/
