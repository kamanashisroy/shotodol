using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup renu Renu(Renu), is a table that contains some values. It is intended for messaging. And modules can register their attributes here and set them while messaging.
 */

/** \addtogroup Renu
 *  @{
 */
public class shotodol.Renu : Replicable {
	HashTable<xtring,Extension>registry;
	Renu?proto;
	public Renu() {
	}
	public int rehash() {
		// get all the extensions in renu directory ..
		return 0;
	}
}
/** @}*/
