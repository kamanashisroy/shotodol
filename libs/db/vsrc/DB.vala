using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup db Database
 */

/** \addtogroup db
 *  @{
 */
public abstract class shotodol.DB : DBOperations {
	public enum DBType {
		DB_IS_REMOTE = 1,
		DB_IS_LOCAL = 1<<1,
		DB_IS_SHARED = 1<<2,
	}
}
/** @}*/
