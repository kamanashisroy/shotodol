using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup pollen Pollen, is a table that contains some values. It is intended for messaging. And modules can register their attributes here and set them while messaging.
 */

/** \addtogroup Pollen
 *  @{
 */
public class shotodol.Pollen : Replicable {
	HashTable<xtring,Extension>registry;
	public Pollen() {
	}
	public int rehash() {
		// get all the extensions in pollen directory ..
		return 0;
	}
}
/** @}*/
