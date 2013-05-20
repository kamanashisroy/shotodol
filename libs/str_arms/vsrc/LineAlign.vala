using aroop;
using shotodol;

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
		words = wds;
		sense = given_sense;
		firstline = null;
	}
	
	public G? get() {
		return sense;
	}
	
	public static int next_token(etxt*src, etxt*next) {
		uint i = 0;
		int len = src.length();
		(*next) = etxt.from_etxt(src);
		for(i = 0; i < len; i++) {
			char x = src.char_at(i);
			if(x == ' ' || x == '\r' || x == '\n') {
				next.trim_to_length(i);
				break;
			}
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
				firstline = new txt(wds.to_string());
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
	
	public G? percept_prefix_match(etxt*pfx) {
		if(firstline != null && pfx.equals(firstline)) {
			return sense;
		}
		return null;
	}
}
