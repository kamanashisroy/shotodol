using aroop;
using shotodol;

public class shotodol.WordSet : Replicable {
	SearchableFactory<txt> words;
	public WordSet() {
		words = SearchableFactory<txt>.for_type();
	}
	~WordSet() {
		words.destroy();
	}

	public txt?add(etxt*wrd) {
		txt?entry = null;
		entry = words.search(wrd.get_hash(), (data) => {
			unowned txt w = ((txt)data);
			if(wrd.equals((etxt*)w)) {
				return 0;
			}
			return -1;
		});
		if(entry != null) {
			return entry;
		}
		entry = words.alloc_full((uint16)sizeof(txt)+(uint16)wrd.length()+1);
		if(entry != null) {
			entry.memcopy_from_etxt(wrd);
		} else {
			// TODO throw error
			return null;
		}
		return entry;
	}
}
