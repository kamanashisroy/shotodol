using aroop;
using shotodol;

/** \addtogroup renu
 *  @{
 */
public class shotodol.RenuFactoryImpl : RenuFactory {
	public Factory<Renu>fac;
	public RenuFactoryImpl() {
		base();
		fac = Factory<Renu>.for_type(64);
	}
	
	~RenuFactoryImpl() {
		fac.destroy();
	}

	public override Renu createRenu(uint16 sz) {
		Renu x = fac.alloc_full((uint16)sizeof(Renu)+sz);
		x.build(sz);
		return x;
	}
}
/** @}*/
