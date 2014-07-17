using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.WordSet : Replicable {
	SearchableFactory<str> words;
	public WordSet() {
		words = SearchableFactory<str>.for_type();
	}
	~WordSet() {
		words.destroy();
	}

	public str?add(estr*wrd) {
		str?entry = null;
		entry = words.search(wrd.getStringHash(), (data) => {
			unowned str w = ((str)data);
			if(wrd.equals((estr*)w)) {
				return 0;
			}
			return -1;
		});
		if(entry != null) {
			return entry;
		}
		entry = words.alloc_full((uint16)sizeof(str)+(uint16)wrd.length()+1);
		if(entry != null) {
			entry.factory_build_by_memcopy_from_estr_unsafe_no_length_check(wrd);
		} else {
			// TODO throw error
			return null;
		}
		return entry;
	}
}
/** @}*/
