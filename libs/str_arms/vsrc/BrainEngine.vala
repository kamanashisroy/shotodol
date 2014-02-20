using aroop;
using shotodol;

public class shotodol.BrainEngine<G> : Replicable {
	//Factory<LineAlign> response;
	Factory<LineAlign<G>> sandbox;
	Factory<LineAlign<G>> memory;
	WordSet words;
	
	public BrainEngine() {
		memory = Factory<LineAlign<G>>.for_type();
		//response = Factory<LineAlign>.for_type();
		sandbox = Factory<LineAlign<G>>.for_type();
		words = new WordSet();
	}
	
	public int memorize_etxt(etxt*wds, G? sense) {
        // find the msg in memory
        LineAlign<G> ln = memory.alloc_full(0,1);
        //LineAlign<G> gn = new (ln) LignAlign<G>(words, sense);
        generihack<LineAlign<G>,G>.build_generics(ln);
        ln.build(words, sense);
        return ln.align_etxt(wds);
	}
	
	public int memorize(InputStream strm, G? sense) {
        // find the msg in memory
        LineAlign<G> ln = memory.alloc_full(0,1);
        generihack<LineAlign<G>,G>.build_generics(ln);
        ln.build(words, sense);
        return ln.align(strm);
	}
	
	public G? percept_prefix_match(etxt*wds) {
		if(wds.is_empty()) {
			return null;
		}		
		G?ret = null;
		int strength = 0;
		memory.visit_each((data) =>{
			unowned LineAlign<G> ln = (LineAlign<G>)data;
			int len = 0;
			G?sense = ln.percept_prefix_match(wds, &len);
			if(strength < len) {
				ret = sense;
				strength = len;
			}
			return 0;
		}, Replica_flags.ALL, 0, 0);
		return ret;
	}
	
	public int percept(etxt word) {
		int similarity = 0;
		// calculate similarity with memory
		return similarity;
	}
}
