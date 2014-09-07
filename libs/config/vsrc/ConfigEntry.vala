using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
internal class ConfigEntry : Replicable {
	internal extring name;
	HashTable<xtring,xtring> tbl;

	~ConfigEntry() {
		tbl.destroy();
	}

	internal void build(extring*myName) {
		name = extring.copy_shallow(myName);
		tbl = HashTable<xtring,xtring>(xtring.hCb,xtring.eCb);
	}

	internal int set(xtring myKey, xtring myValue) {
		return tbl.set(myKey, myValue);
	}
	internal void getAs(extring*key, extring*outValue) {
		xtring?v = tbl.get((xtring)key);
		if(v != null)
		outValue.rebuild_and_copy_on_demand(v);
	}
}
/** @}*/
