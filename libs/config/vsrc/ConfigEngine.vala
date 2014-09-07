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
public class shotodol.ConfigEngine : Replicable {
	HashTable<xtring,ConfigModuleEntry> modules;
	internal Factory<ConfigModuleEntry> moduleSource;
	internal Factory<ConfigEntry> entrySource;
	public ConfigEngine() {
		modules = HashTable<xtring,ConfigModuleEntry>(xtring.hCb,xtring.eCb);
		entrySource = Factory<ConfigEntry>.for_type();
		moduleSource = Factory<ConfigModuleEntry>.for_type();
	}
	~ConfigEngine() {
		modules.destroy();
		entrySource.destroy();
		moduleSource.destroy();
	}

	public int getValueAs(extring*moduleName, extring*grp, extring*key, extring*outValue) {
		ConfigModuleEntry? module = modules.get((xtring)moduleName);
		if(module == null)
			return 0;
		ConfigEntry?entry = module.get((xtring)grp);
		if(entry == null)
			return 0;
		entry.getAs(key, outValue);
		return 0;
	}
	
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
						if(val.fly().char_at(0) == ' ') {
							val.fly().shift(1);
						}
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
