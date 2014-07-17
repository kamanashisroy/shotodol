using aroop;
using shotodol;

/**
 * \ingroup library
 * \defgroup config Config Engine(config)
 * [Cohesion : Functional]
 */

/** \addtogroup config
 *  @{
 */
public abstract class shotodol.ConfigEngine : Replicable {
	HashTable<ConfigModuleEntry> modules;
	internal Factory<ConfigModuleEntry> moduleSource;
	internal Factory<ConfigEntry> entrySource;
	public ConfigEngine() {
		modules = HashTable<ConfigModuleEntry>();
		entrySource = Factory<ConfigEntry>.for_type();
		moduleSource = Factory<ConfigModuleEntry>.for_type();
	}
	~Config() {
		modules.destroy();
		entrySource.destroy();
		moduleSource.destroy();
	}
#if false
	public int getConfig(estr*moduleName, estr*grp, ) {
		container<str>? mod;
		if((mod = vals.search(id, match_all)) == null) {
			return -1;
		}
		output.cat(mod.get());
		return 0;
	}
#endif
	
	public int parseEntry(estr*data) {
		estr token = estr();
		estr inp = estr.stack_copy_deep(data);
		int count = 0;
		str? myModuleName = null;
		str? myEntryName = null;
		str? myKey = null;
		for(count = 0; count < 3; count++) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			switch(count) {
				case 0:
					myModuleName = new str.copy_deep(&token);
				break;
				case 1:
					myEntryName = new str.copy_deep(&token);
				break;
				case 2:
					myKey = new str.copy_deep(&token);
					{
						ConfigModuleEntry? module = modules.get(myModuleName);
						if(module == null) {
							module = moduleSource.alloc_full();
							if(module == null) {
								break;
							}
							module.build(myModuleName);
							modules.set(myModuleName, module);
						}
						str val = new str.copy_deep(&inp);
						module.set(entrySource, myEntryName, myKey, val);
					}
				break;
				default:
				break;
			}
		}
		return 0;
	}
}
/** @}*/
