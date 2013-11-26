using aroop;

internal class M100Statement: Replicable {
	enum m100_op {
		ASSIGN,
		SUFFIX,
	}
	txt dest;
	txt exp;
	m100_op op;
	public M100Statement(etxt*given_dest, etxt*given_op, etxt*given_exp) {
		if(given_op.equals_static_string(":=")) {
			op = m100_op.ASSIGN;
		} else if(given_op.equals_static_string("+=")) {
			op = m100_op.SUFFIX;
		} else {
			// throw error
		}
		dest = new txt.memcopy(given_dest.to_string(), given_dest.length());
		exp = new txt.memcopy(given_exp.to_string(), given_exp.length());
	}
}

