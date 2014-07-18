using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.WordSet : Replicable {
	SearchableFactory<xtring> words;
	public WordSet() {
		words = SearchableFactory<xtring>.for_type();
	}
	~WordSet() {
		words.destroy();
	}

	public xtring?add(extring*wrd) {
		xtring?entry = null;
		entry = words.search(wrd.getStringHash(), (data) => {
			unowned xtring w = ((xtring)data);
			if(wrd.equals((extring*)w)) {
				return 0;
			}
			return -1;
		});
		if(entry != null) {
			return entry;
		}
		entry = words.alloc_full((uint16)sizeof(xtring)+(uint16)wrd.length()+1);
		if(entry != null) {
			entry.ecast().factory_build_and_copy_on_tail_no_length_check(wrd);
		} else {
			// TODO throw error
			return null;
		}
		return entry;
	}
}
/** @}*/
