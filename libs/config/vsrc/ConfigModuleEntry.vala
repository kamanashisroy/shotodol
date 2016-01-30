using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
internal class ConfigModuleEntry : Replicable {
	internal extring moduleName;
	HashTable<xtring,ConfigEntry> entries;

	~ConfigModuleEntry() {
		entries.destroy();
	}

	internal void build(extring*myModuleName) {
		moduleName = extring.copy_on_demand(myModuleName);
		entries = HashTable<xtring,ConfigEntry>(xtring.hCb,xtring.eCb);
	}
	internal int set(OPPFactory<ConfigEntry> source, xtring entryName, xtring myKey, xtring myValue) {
		unowned ConfigEntry? entry = entries.get(entryName);
		if(entry == null) {
			ConfigEntry newEntry = source.alloc_full();
			if(newEntry == null) {
				return -1;
			}
			newEntry.build(entryName);
			entries.set(entryName, newEntry);
			entry = newEntry;
		}
		entry.set(myKey, myValue);
		return 0;
	}
	internal ConfigEntry? get(extring*entryName) {
		return entries.get((xtring)entryName);
	}
}
/** @}*/
