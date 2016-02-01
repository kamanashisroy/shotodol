using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.Context<G> : Replicable {
	//OPPFactory<LineExpression> response;
	//OPPFactory<LineExpression<G>> sandbox;
	OPPFactory<LineExpression<G>> memory;
	WordSet words;
	
	public Context() {
		memory = OPPFactory<LineExpression<G>>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
		//response = OPPFactory<LineExpression>.for_type();
		//sandbox = OPPFactory<LineExpression<G>>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
		words = new WordSet();
	}

	~Context() {
		memory.destroy();
		//sandbox.destroy();
	}
	
	public int assign_estr(extring*wds, G? sense) {
		if(wds == null || wds.is_empty_magical()) {
			return -1;
		}
		LineExpression<G> ln = LineExpression.factoryBuild(&memory,words,sense);
		ln.pin();
		return ln.align_estr(wds);
	}
	
	public int assign(InputStream strm, G? sense) {
		LineExpression<G> ln = LineExpression.factoryBuild(&memory,words,sense);
		ln.pin();
		return ln.align(strm);
	}
	
	public G? lookup_prefix_match(extring*wds) {
		if(wds.is_empty_magical()) {
			return null;
		}		
		G?ret = null;
		int strength = 0;
		memory.visit_each((data) =>{
			unowned LineExpression<G> ln = (LineExpression<G>)data;
			int len = 0;
			G?sense = ln.lookup_prefix_match(wds, &len);
			if(strength < len) {
				ret = sense;
				strength = len;
			}
			sense = null;
			return 0;
		}, Replica_flags.ALL, 0, 0);
		return ret;
	}
	
	public int lookup(extring word) {
		int similarity = 0;
		// calculate similarity with memory
		return similarity;
	}
}
/** @}*/
