using aroop;
using shotodol;

public class shotodol.LineAlign : Replicable {
	WordSet? words;
	SearchableSet<txt> aln;
	
	public LineAlign(WordSet wds) {
		words = wds;
	}
	
	~LineAlign() {
		words = null;
	}
	
	public void build(WordSet wds) {
		words = wds;
	}
	
	int next_token(etxt*src, etxt*next) {
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
		return 0;
	}
	
	public int align(InputStream strm) {
		etxt rd = etxt.stack(128);
		while(true) {
			strm.read(&rd);
			if(rd.is_empty()) {
				break;
			}
			etxt next = etxt.EMPTY();
			next_token(&rd, &next);
			if(next.is_empty()) {
				continue;
			}
			// put in words
			txt wdtxt = words.add(&next);
			if(wdtxt != null) {
				// align the word
				aln.add(wdtxt);
			}
		}
		// done
		return 0;
	}
}
