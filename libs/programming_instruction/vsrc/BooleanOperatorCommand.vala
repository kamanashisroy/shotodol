using aroop;
using shotodol;

/** \addtogroup control_command
 *  @{
 */
public class shotodol.BooleanOperatorCommand : shotodol.M100Command {
	enum Options {
		X = 1,
		Y,
		Z,
	}
	public BooleanOperatorCommand(estr*prefix) {
		base(prefix);
		addOptionString("-x", M100Command.OptionType.TXT, Options.X, "First variable or value");
		addOptionString("-y", M100Command.OptionType.TXT, Options.Y, "Second variable or value");
		addOptionString("-z", M100Command.OptionType.TXT, Options.Z, "Output variable");
	}

	public override int act_on(estr*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<str> vals = ArrayList<str>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		str?x = vals[Options.X];
		if(x == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		str?y = vals[Options.Y];
		if(y == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		if(x.ecast().is_empty_magical() || y.ecast().is_empty_magical()) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		str?z = vals[Options.Z];
		if(x == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		if(z.ecast().is_empty_magical() || (z.ecast().char_at(0) - '0') <= 9) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
#if false
		int outlen = x.length() + y.length() + 128;
		estr out = estr.stack(outlen);
#endif
		uchar xdigit = x.ecast().char_at(0) - '0';
		estr dlg = estr.stack(128);
		dlg.printf("%s comparison\n", ((xdigit <= 9) && (xdigit >= 0)) ? "Integer" : "String" );
		pad.write(&dlg);
#if false
		int val = execOperation(&out,x,y,(xdigit <= 9) && (xdigit >= 0));
#else
		int val = execOperation(x,y,(xdigit <= 9) && (xdigit >= 0));
#endif
		M100Variable mval = new M100Variable();
		mval.setBool(val == 1?true:false);
		cmds.vars.set(z, mval);
		return 0;
	}
	protected virtual int execOperation(str x, str y, bool isInt) {
		return 0;
	}
}
internal class shotodol.LessThanCommand : shotodol.BooleanOperatorCommand {
	public LessThanCommand() {
		estr prfx = estr.copy_static_string("lt");
		base(&prfx);
	}
	protected override int execOperation(str x, str y, bool isInt) {
		if(isInt) {
			int xval = ((estr*)x).to_int();
			int yval = ((estr*)y).to_int();
			if(xval < yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.GreaterThanCommand : shotodol.BooleanOperatorCommand {
	public GreaterThanCommand() {
		estr prfx = estr.copy_static_string("gt");
		base(&prfx);
	}
	protected override int execOperation(str x, str y, bool isInt) {
		if(isInt) {
			int xval = ((estr*)x).to_int();
			int yval = ((estr*)y).to_int();
			if(xval > yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.EqualsCommand : shotodol.BooleanOperatorCommand {
	public EqualsCommand() {
		estr prfx = estr.copy_static_string("gt");
		base(&prfx);
	}
	protected override int execOperation(str x, str y, bool isInt) {
		if(isInt) {
			int xval = x.ecast().to_int();
			int yval = y.ecast().to_int();
			if(xval == yval) {
				return 1;
			}
		} else if(x.ecast().equals(y)) {
			return 1;
		}
		return 0;
	}
}
/* @} */
