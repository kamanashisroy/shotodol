using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
internal class ConfigEntry : Replicable {
	internal estr name;
	HashTable<str> tbl;

	~ConfigEntry() {
		tbl.destroy();
	}

	internal void build(estr*myName) {
		name = estr.copy_shallow(myName);
		tbl = HashTable<str>();
	}

	internal int set(str myKey, str myValue) {
		return tbl.set(myKey, myValue);
	}
}
/** @}*/
