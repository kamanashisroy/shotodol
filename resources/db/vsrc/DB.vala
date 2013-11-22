using aroop;
using shotodol;

public abstract class shotodol.DB : Replicable {
	public enum DBType {
		DB_IS_REMOTE = 1,
		DB_IS_LOCAL = 1<<1,
		DB_IS_SHARED = 1<<2,
	}
	/*public DB(DBType tp, etxt*address) {
		// unimplemented
	}*/
}
