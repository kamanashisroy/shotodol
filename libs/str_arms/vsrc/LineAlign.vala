using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.LineAlign<G> : Replicable {
	WordSet? words;
	SearchableOPPList<SearchableString> aln;
	G?sense;
	xtring?firstline;
	public LineAlign(WordSet wds,G?given_sense) {
		build(wds, given_sense);
	}
	
	~LineAlign() {
		words = null;
		sense = null;
		aln.destroy();
	}
	
	void build(WordSet wds, G?given_sense) {
		memclean_raw();	// clear garbage
		aln = SearchableOPPList<SearchableString>();
		words = wds;
		sense = given_sense;
		firstline = null;
	}

	public static LineAlign<G> factoryBuild(Factory<LineAlign<G>>*fac, WordSet wds, G?given_sense) {
		LineAlign<G> ln = fac.alloc_full();
		//generihack<LineAlign<G>,G>.build_generics(ln); // what does it do ?
		ln.build(wds, given_sense);
		return ln;
	}
	
	public G? get() {
		return sense;
	}

	public static int next_token_delimitered_unused(extring*src, extring*next, extring*delim, extring*wordDivider = null) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			if((wordDivider == null && (x == ' ' || x == '\r' || x == '\n')) || wordDivider.contains_char(x)) {
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
			next.rebuild_and_copy_shallow(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
		}
		src.shift((int)i);
		return 0;
	}

	public static int next_token_delimitered(extring*src, extring*next, extring*delim) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			token_start = (token_start < 0) ? (int)i : token_start;
			if(delim.contains_char(x)) {
				if(token_start == i) {
					i++;
				}
				trim_at = (int)i;
				break;
			}
		}
		if(token_start >= 0) {
			next.rebuild_and_copy_shallow(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
		}
		src.shift((int)i);
		return 0;
	}


	public static int next_token_delimitered_sliteral(extring*src, extring*next, extring*delim, extring*wordDivider = null) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		bool stringLiteral = false;
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
			bool isQuote = (x == '\"');
			if((stringLiteral && isQuote) || ( !stringLiteral && ((wordDivider == null && (x == ' ' || x == '\r' || x == '\n' || isQuote)) || wordDivider.contains_char(x)) ) ) {
				if(token_start == -1) {
					if(isQuote) {
						stringLiteral = true;
						token_start = (int)i+1; // skip the quotation mark ..
					}
					continue;
				} else if(stringLiteral && isQuote) {
					trim_at = (int)i;
					i++; // skip the quotation mark ..
					break;
				}
				trim_at = (int)i;
				break;
			} else {
				token_start = (token_start < 0) ? (int)i : token_start;
				if(!stringLiteral && delim.contains_char(x)) {
					if(token_start == i) {
						i++; // this is one character token, it should contain only the delimiter
					}
					trim_at = (int)i;
					break;
				}
			}
		}
		if(token_start >= 0) {
			next.rebuild_and_copy_shallow(src);
			//(*next) = extring.share_estr(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
			//(*next) = extring.EMPTY();
		}
		src.shift((int)i);
		return 0;
	}


	public static int next_token(extring*src, extring*next) {
		uint i = 0;
		int token_start = -1;
		int trim_at = -1;
		int len = src.length();
		for(i = 0; i < len; i++) {
			uchar x = src.char_at(i);
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
			next.rebuild_and_copy_shallow(src);
			//(*next) = extring.share_estr(src);
			if(trim_at >= 0) {
				next.truncate(trim_at);
			}
			next.shift(token_start);
		} else {
			next.truncate();
			//(*next) = extring.EMPTY();
		}
		src.shift((int)i);
		return 0;
	}
	
	public int align_word(extring*wd) {
		if(wd.is_empty()) {
			return 0;
		}
		// put in words
		SearchableString wdtxt = words.add(wd);
		if(wdtxt != null) {
			// align the word
			aln.add(wdtxt);
		}
		return 0;
	}
	
	public int align_estr(extring*wds) {
		if(wds.is_empty()) {
			return 0;
		}
		while(true) {
			if(firstline == null) {
				firstline = new xtring.copy_deep(wds);
			}
			extring next = extring();
			next_token(wds, &next);
			if(next.is_empty()) {
				break;
			}
			align_word(&next);
		}
		return 0;
	}
	
	public int align(InputStream strm) {
		extring rd = extring.stack(128);
		while(true) {
			strm.read(&rd);
			if(rd.is_empty()) {
				break;
			}
			align_estr(&rd);
		}
		// done
		return 0;
	}
	
	private int prefix_match(extring*pfx) requires(pfx != null && firstline != null) {
		core.assert(pfx != null && firstline != null);
		int i = 0;
		for(;i<firstline.fly().length() && i<pfx.length() && firstline.fly().char_at(i) == pfx.char_at(i);i++);
		return i;
	}
	
	public G? percept_prefix_match(extring*pfx, int*match_len) {
		*match_len = prefix_match(pfx);
		if(*match_len > 0) {
			return sense;
		}
		return null;
	}
}
/** @}*/
