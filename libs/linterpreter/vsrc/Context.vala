using aroop;
using shotodol;

/** \addtogroup str_arms
 *  @{
 */
public class shotodol.Context<G> : Replicable {
	OPPFactory<LineExpression<G>> memory;
	
	public Context() {
		memory = OPPFactory<LineExpression<G>>.for_type(16, 0, factory_flags.MEMORY_CLEAN);
	}

	~Context() {
		memory.destroy();
	}
	
	public int assign_estr(extring*wds, G? sense) {
		if(wds == null || wds.is_empty_magical()) {
			return -1;
		}
		LineExpression<G> ln = LineExpression.factoryBuild(&memory,sense);
		ln.pin();
		return ln.align_estr(wds);
	}
	
	public int assign(InputStream strm, G? sense) {
		LineExpression<G> ln = LineExpression.factoryBuild(&memory,sense);
		ln.pin();
		return ln.align(strm);
	}
	
	public G? lookup_by_prefix(extring*wds) {
		if(wds.is_empty_magical()) {
			return null;
		}		
		G?ret = null;
		int strength = 0;
		memory.visit_each((data) =>{
			unowned LineExpression<G> ln = (LineExpression<G>)data;
			int len = 0;
			G?sense = ln.lookup_by_prefix(wds, &len);
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
