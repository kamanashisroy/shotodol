using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
#if false
public class shotodol.Dictionary : Replicable {
	SearchableOPPFactory<SearchableString> words;
	public Dictionary() {
		words = SearchableOPPFactory<SearchableString>.for_type();
	}
	~Dictionary() {
		words.destroy();
	}

	public SearchableString?add(extring*wrd) {
		core.assert(!wrd.is_empty());
		SearchableString?entry = null;
		entry = words.search(wrd.getStringHash(), (data) => {
			unowned SearchableString w = ((SearchableString)data);
			if(wrd.equals(&w.tdata)) {
				return 0;
			}
			return -1;
		});
		if(entry != null) {
			return entry;
		}
		entry = SearchableString.factory_build_and_copy_deep(&words,wrd);
		return entry;
	}
}
#endif
/** @}*/
