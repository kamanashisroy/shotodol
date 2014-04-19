using aroop;
using shotodol;

/** \addtogroup config
 *  @{
 */
internal class ConfigModuleEntry : Replicable {
	internal etxt moduleName;
	HashTable<ConfigEntry> entries;

	~ConfigModuleEntry() {
		entries.destroy();
	}

	internal void build(etxt*myModuleName) {
		moduleName = etxt.same_same(myModuleName);
		entries = HashTable<ConfigEntry>();
	}
	internal int set(Factory<ConfigEntry> source, txt entryName, txt myKey, txt myValue) {
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
