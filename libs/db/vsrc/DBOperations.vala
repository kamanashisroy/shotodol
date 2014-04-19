using aroop;
using shotodol;

/** \addtogroup db
 *  @{
 */
public abstract class shotodol.DBOperations : Replicable {
	public virtual int save(DBId id, DBEntry entry) {
		core.die("unimplemented");
		return 0;
	}
	
	public virtual DBEntry? remove_by_hash(DBId id) {
		core.die("unimplemented");
		return null;
	}
	
	public virtual DBEntry? remove(DBId id, DBEntry entry) {
		core.die("unimplemented");
		return null;
	}
	
	public virtual DBEntry? load(DBId id) {
		core.die("unimplemented");
		return null;
	}
}
/** @}*/
