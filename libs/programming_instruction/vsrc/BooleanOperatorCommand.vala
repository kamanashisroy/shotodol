using aroop;
using shotodol;

/** \addtogroup control_command
 *  @{
 */
public class shotodol.BooleanOperatorCommand : shotodol.M100Command {
	etxt prfx;
	unowned M100CommandSet cmds;
	enum Options {
		X = 1,
		Y,
		Z,
	}
	public BooleanOperatorCommand(M100CommandSet gCmds) {
		base();
		cmds = gCmds;
		addOptionString("-x", M100Command.OptionType.TXT, Options.X, "First variable or value");
		addOptionString("-y", M100Command.OptionType.TXT, Options.Y, "Second variable or value");
		addOptionString("-z", M100Command.OptionType.TXT, Options.Z, "Output variable");
	}
	public override int act_on(etxt*cmdstr, OutputStream pad) throws M100CommandError.ActionFailed {
		ArrayList<txt> vals = ArrayList<txt>();
		if(parseOptions(cmdstr, &vals) != 0) {
			throw new M100CommandError.ActionFailed.INVALID_ARGUMENT("Invalid argument");
		}
		txt?x = vals[Options.X];
		if(x == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		txt?y = vals[Options.Y];
		if(y == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		if(x.is_empty_magical() || y.is_empty_magical()) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		txt?z = vals[Options.Z];
		if(x == null) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
		if(z.is_empty_magical() || (z.char_at(0) - '0') <= 9) {
			throw new M100CommandError.ActionFailed.INSUFFICIENT_ARGUMENT("Insufficient argument");
		}
#if false
		int outlen = x.length() + y.length() + 128;
		etxt out = etxt.stack(outlen);
#endif
		uchar xdigit = x.char_at(0) - '0';
		etxt dlg = etxt.stack(128);
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
	protected virtual int execOperation(txt x, txt y, bool isInt) {
		return 0;
	}
}
internal class shotodol.LessThanCommand : shotodol.BooleanOperatorCommand {
	etxt prfx;
	public LessThanCommand(M100CommandSet cmds) {
		base(cmds);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("lt");
		return &prfx;
	}
	protected override int execOperation(txt x, txt y, bool isInt) {
		if(isInt) {
			int xval = ((etxt*)x).to_int();
			int yval = ((etxt*)y).to_int();
			if(xval < yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.GreaterThanCommand : shotodol.BooleanOperatorCommand {
	etxt prfx;
	public GreaterThanCommand(M100CommandSet cmds) {
		base(cmds);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("gt");
		return &prfx;
	}
	protected override int execOperation(txt x, txt y, bool isInt) {
		if(isInt) {
			int xval = ((etxt*)x).to_int();
			int yval = ((etxt*)y).to_int();
			if(xval > yval) {
				return 1;
			}
		}
		return 0;
	}
}
internal class shotodol.EqualsCommand : shotodol.BooleanOperatorCommand {
	etxt prfx;
	public EqualsCommand(M100CommandSet cmds) {
		base(cmds);
	}
	public override etxt*get_prefix() {
		prfx = etxt.from_static("eq");
		return &prfx;
	}
	protected override int execOperation(txt x, txt y, bool isInt) {
		if(isInt) {
			int xval = ((etxt*)x).to_int();
			int yval = ((etxt*)y).to_int();
			if(xval == yval) {
				return 1;
			}
		} else if(x.equals(y)) {
			return 1;
		}
		return 0;
	}
}
/* @} */
