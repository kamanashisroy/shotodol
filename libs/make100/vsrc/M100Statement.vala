using aroop;

/** \addtogroup make100
 *  @{
 */
internal class M100Statement: Replicable {
	enum m100_op {
		ASSIGN,
		SUFFIX,
	}
	xtring dest;
	xtring exp;
	m100_op op;
	public M100Statement(extring*given_dest, extring*given_op, extring*given_exp) {
		if(given_op.equals_static_string(":=")) {
			op = m100_op.ASSIGN;
		} else if(given_op.equals_static_string("+=")) {
			op = m100_op.SUFFIX;
		} else {
			// throw error
		}
		dest = new xtring.copy_on_demand(given_dest);
		exp = new xtring.copy_on_demand(given_exp);
	}
}
/** @}*/
