using aroop;
using shotodol;

/** \addtogroup bag
 *  @{
 */
public class shotodol.BagFactoryImpl : BagFactory {
	public OPPFactory<Bag>fac;
	public BagFactoryImpl() {
		base();
		fac = OPPFactory<Bag>.for_type(64);
	}
	
	~BagFactoryImpl() {
		fac.destroy();
	}

	public override Bag createBag(uint16 sz) {
		Bag x = fac.alloc_full((uint16)sizeof(Bag)+sz);
		x.build(sz);
		return x;
	}
}
/** @}*/
