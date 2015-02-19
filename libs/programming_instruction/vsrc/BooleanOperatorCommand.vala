using aroop;
using shotodol;

/**
 * \ingroup command_programming
 * \defgroup control_command Control statement support for command scripts.
 */


/** \addtogroup control_command
 *  @{
 */
public class shotodol.BooleanOperatorCommand : shotodol.M100Command {
	enum Options {
		X = 1,
		Y,
		Z,
	}
	public BooleanOperatorCommand(extring*prefix) {
		base(prefix);
		addOptionString("-x", M100Command.OptionType.TXT, Options.X, "First variable or value");
		addOptionString("-y", M100Command.OptionType.TXT, Options.Y, "Second variable or value");
		addOptionString("-z", M100Command.OptionType.TXT, Options.Z, "Output variable");
	}

	public override int act_on(extring*cmdstr, OutputStream pad, M100CommandSet cmds) throws M100CommandError.ActionFailed {
		ArrayList<xtring> vals = ArrayList<xtring>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		xtring?x = vals[Options.X];
		if(x == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		xtring?y = vals[Options.Y];
		if(y == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		if(x.fly().is_empty_magical() || y.fly().is_empty_magical()) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		xtring?z = vals[Options.Z];
		if(x == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		if(z.fly().is_empty_magical() || (z.fly().char_at(0) - '0') <= 9) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
#if false
		int outlen = x.length() + y.length() + 128;
		extring out = extring.stack(outlen);
#endif
		uchar xdigit = x.fly().char_at(0) - '0';
		extring dlg = extring.stack(128);
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
	protected virtual int execOperation(xtring x, xtring y, bool isInt) {
		return 0;
	}
}
internal class shotodol.LessThanCommand : shotodol.BooleanOperatorCommand {
	public LessThanCommand() {
		extring prfx = extring.copy_static_string("lt");
		base(&prfx);
	}
	protected override int execOperation(xtring x, xtring y, bool isInt) {
		if(isInt) {
			int xval = ((extring*)x).to_int();
			int yval = ((extring*)y).to_int();
			if(xval < yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.GreaterThanCommand : shotodol.BooleanOperatorCommand {
	public GreaterThanCommand() {
		extring prfx = extring.copy_static_string("gt");
		base(&prfx);
	}
	protected override int execOperation(xtring x, xtring y, bool isInt) {
		if(isInt) {
			int xval = ((extring*)x).to_int();
			int yval = ((extring*)y).to_int();
			if(xval > yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.EqualsCommand : shotodol.BooleanOperatorCommand {
	public EqualsCommand() {
		extring prfx = extring.copy_static_string("gt");
		base(&prfx);
	}
	protected override int execOperation(xtring x, xtring y, bool isInt) {
		if(isInt) {
			int xval = x.fly().to_int();
			int yval = y.fly().to_int();
			if(xval == yval) {
				return 1;
			}
		} else if(x.fly().equals(y)) {
			return 1;
		}
		return 0;
	}
}
/* @} */
