using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
internal class ConfigEntry : Replicable {
	internal extring name;
	HashTable<xtring> tbl;

	~ConfigEntry() {
		tbl.destroy();
	}

	internal void build(extring*myName) {
		name = extring.copy_shallow(myName);
		tbl = HashTable<xtring>();
	}

	internal int set(xtring myKey, xtring myValue) {
		return tbl.set(myKey, myValue);
	}
}
/** @}*/
