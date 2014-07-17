using aroop;
using shotodol;

/** \addtogroup db
 *  @{
 */

public class shotodol.DBFactory : Replicable {
	public static int init() {
		DBEntryFactory.init();
		return 0;
	}
	public static int deinit() {
		DBEntryFactory.deinit();
		return 0;
	}

	public static DB? create(DB.DBType tp, estr*address) {
		if(address.char_at(0) == 'm' && address.char_at(1) == 'e' && address.char_at(2) == 'm') {
			return new MemoryDB(tp, address);
		}
		return null;
	}
	
}
/** @}*/
