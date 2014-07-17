using aroop;

/** \addtogroup make100
 *  @{
 */
internal class M100Statement: Replicable {
	enum m100_op {
		ASSIGN,
		SUFFIX,
	}
	str dest;
	str exp;
	m100_op op;
	public M100Statement(estr*given_dest, estr*given_op, estr*given_exp) {
		if(given_op.equals_static_string(":=")) {
			op = m100_op.ASSIGN;
		} else if(given_op.equals_static_string("+=")) {
			op = m100_op.SUFFIX;
		} else {
			// throw error
		}
		dest = new str.copy_on_demand(given_dest);
		exp = new str.copy_on_demand(given_exp);
	}
}
/** @}*/
