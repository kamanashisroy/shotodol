using aroop;
using shotodol;

public abstract class shotodol.ConfigEngine : Replicable {
	HashTable<ConfigModuleEntry> modules;
	internal Factory<ConfigModuleEntry> moduleSource;
	internal Factory<ConfigEntry> entrySource;
	public ConfigEngine() {
		entrySource = Factory<ConfigEntry>.for_type();
		moduleSource = Factory<ConfigModuleEntry>.for_type();
	}
	~Config() {
		entrySource.destroy();
		moduleSource.destroy();
	}
#if false
	public int getConfig(etxt*moduleName, etxt*grp, ) {
		container<txt>? mod;
		if((mod = vals.search(id, match_all)) == null) {
			return -1;
		}
		output.cat(mod.get());
		return 0;
	}
#endif
	
	internal int parseEntry(etxt*data) {
		etxt token = etxt.EMPTY();
		etxt inp = etxt.stack_from_etxt(data);
		int count = 0;
		txt? myModuleName = null;
		txt? myEntryName = null;
		txt? myKey = null;
		for(count = 0; count < 3; count++) {
			LineAlign.next_token(&inp, &token);
			if(token.is_empty_magical()) {
				break;
			}
			switch(count) {
				case 0:
					myModuleName = new txt.memcopy_etxt(&token);
				break;
				case 1:
					myEntryName = new txt.memcopy_etxt(&token);
				break;
				case 2:
					myKey = new txt.memcopy_etxt(&token);
					{
						ConfigModuleEntry? module = modules.get(myModuleName);
						if(module == null) {
							module = moduleSource.alloc_full();
							if(module == null) {
								break;
							}
							modules.set(myModuleName, module);
						}
						txt val = new txt.memcopy_etxt(&inp);
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
