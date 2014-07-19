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
	HashTable<xtring,ConfigModuleEntry> modules;
	internal Factory<ConfigModuleEntry> moduleSource;
	internal Factory<ConfigEntry> entrySource;
	public ConfigEngine() {
		modules = HashTable<xtring,ConfigModuleEntry>(xtring.hCb,xtring.eCb);
		entrySource = Factory<ConfigEntry>.for_type();
		moduleSource = Factory<ConfigModuleEntry>.for_type();
	}
	~Config() {
		modules.destroy();
		entrySource.destroy();
		moduleSource.destroy();
	}
#if false
	public int getConfig(extring*moduleName, extring*grp, ) {
		container<xtring>? mod;
		if((mod = vals.search(id, match_all)) == null) {
			return -1;
		}
		output.cat(mod.get());
		return 0;
	}
#endif
	
	public int parseEntry(extring*data) {
		extring token = extring();
		extring inp = extring.stack_copy_deep(data);
		int count = 0;
		xtring? myModuleName = null;
		xtring? myEntryName = null;
		xtring? myKey = null;
		for(count = 0; count < 3; count++) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			switch(count) {
				case 0:
					myModuleName = new xtring.copy_deep(&token);
				break;
				case 1:
					myEntryName = new xtring.copy_deep(&token);
				break;
				case 2:
					myKey = new xtring.copy_deep(&token);
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
						xtring val = new xtring.copy_deep(&inp);
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
