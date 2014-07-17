using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
internal class ConfigModuleEntry : Replicable {
	internal estr moduleName;
	HashTable<ConfigEntry> entries;

	~ConfigModuleEntry() {
		entries.destroy();
	}

	internal void build(estr*myModuleName) {
		moduleName = estr.copy_on_demand(myModuleName);
		entries = HashTable<ConfigEntry>();
	}
	internal int set(Factory<ConfigEntry> source, str entryName, str myKey, str myValue) {
		ConfigEntry? entry = entries.get(entryName);
		if(entry == null) {
			entry = source.alloc_full();
			if(entry == null) {
				return -1;
			}
			entry.build(entryName);
			entries.set(entryName, entry);
		}
		entry.set(myKey, myValue);
		return 0;
	}
}
/** @}*/
