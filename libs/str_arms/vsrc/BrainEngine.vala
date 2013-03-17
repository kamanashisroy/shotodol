using aroop;
using shotodol;

public class shotodol.BrainEngine : Replicable {
	//Factory<LineAlign> response;
	Factory<LineAlign> sandbox;
	Factory<LineAlign> memory;
	WordSet words;
	
	public BrainEngine() {
		memory = Factory<LineAlign>.for_type();
		//response = Factory<LineAlign>.for_type();
		sandbox = Factory<LineAlign>.for_type();
		words = new WordSet();
	}
	
	public int memorize(InputStream strm) {
        // find the msg in memory
        LineAlign ln = memory.alloc_full();
        ln.build(words);
        return ln.align(strm);
	}
	
	public int percept(etxt word) {
		int similarity = 0;
		// calculate similarity with memory
		return similarity;
	}
}
