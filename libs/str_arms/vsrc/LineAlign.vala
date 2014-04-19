using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.LineAlign<G> : Replicable {
	WordSet? words;
	SearchableSet<txt> aln;
	G?sense;
	txt?firstline;
	public LineAlign(WordSet wds,G?given_sense) {
		build(wds, given_sense);
	}
	
	~LineAlign() {
		words = null;
		sense = null;
		aln.destroy();
	}
	
	public void build(WordSet wds, G?given_sense) {
		aln = SearchableSet<txt>();
		words = wds;
		sense = given_sense;
		firstline = null;
	}
	
	public G? get() {
		return sense;
	}
		
	public static int next_token_delimitered(etxt*src, etxt*next, etxt*delim) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			char x = src.char_at(i);
			if(x == ' ' || x == '\r' || x == '\n') {
				if(token_start == -1) {
					continue;
				}
				trim_at = (int)i;
				break;
			} else {
				token_start = (token_start < 0) ? (int)i : token_start;
				if(delim.contains_char(x)) {
					if(token_start == i) {
						i++;
					}
					trim_at = (int)i;
					break;
				}
			}
		}
		if(token_start >= 0) {
			(*next) = etxt.share_etxt(src);
			if(trim_at >= 0) {
				next.trim_to_length(trim_at);
			}
			next.shift(token_start);
		} else {
			(*next) = etxt.EMPTY();
		}
		src.shift((int)i);
		return 0;
	}

	public static int next_token(etxt*src, etxt*next) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			char x = src.char_at(i);
			if(x == ' ' || x == '\r' || x == '\n') {
				if(token_start == -1) {
					continue;
				}
				trim_at = (int)i;
				break;
			} else {
				token_start = (token_start < 0) ? (int)i : token_start;
			}
		}
		if(token_start >= 0) {
			(*next) = etxt.share_etxt(src);
			if(trim_at >= 0) {
				next.trim_to_length(trim_at);
			}
			next.shift(token_start);
		} else {
			(*next) = etxt.EMPTY();
		}
		src.shift((int)i);
		return 0;
	}
	
	public int align_word(etxt*wd) {
		if(wd.is_empty()) {
			return 0;
		}
		// put in words
		txt wdtxt = words.add(wd);
		if(wdtxt != null) {
			// align the word
			aln.add(wdtxt);
		}
		return 0;
	}
	
	public int align_etxt(etxt*wds) {
		if(wds.is_empty()) {
			return 0;
		}
		while(true) {
			if(firstline == null) {
				firstline = new txt.memcopy(wds.to_string(),wds.length());
			}
			etxt next = etxt.EMPTY();
			next_token(wds, &next);
			if(next.is_empty()) {
				break;
			}
			align_word(&next);
		}
		return 0;
	}
	
	public int align(InputStream strm) {
		etxt rd = etxt.stack(128);
		while(true) {
			strm.read(&rd);
			if(rd.is_empty()) {
				break;
			}
			align_etxt(&rd);
		}
		// done
		return 0;
	}
	
	private int prefix_match(etxt*pfx) requires(pfx != null && firstline != null) {
		int i = 0;
		for(;i<firstline.length() && i<pfx.length() && firstline.char_at(i) == pfx.char_at(i);i++);
		return i;
	}
	
	public G? percept_prefix_match(etxt*pfx, int*match_len) {
		*match_len = prefix_match(pfx);
		if(*match_len > 0) {
			return sense;
		}
		return null;
	}
}
/** @}*/
